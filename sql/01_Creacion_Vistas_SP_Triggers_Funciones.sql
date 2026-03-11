USE hotel_regional;

-- ======================================
-- VISTAS
-- ======================================
-- Vista 1:
CREATE OR REPLACE VIEW vista_servicios_reservas AS
SELECT 
    r.reserva_id,
    h.nombre AS huesped,
    s.nombre AS servicio,
    rs.cantidad,
    (s.precio * rs.cantidad) AS subtotal
FROM reserva_servicio rs
JOIN reservas r ON rs.reserva_id = r.reserva_id
JOIN servicios s ON rs.servicio_id = s.servicio_id
JOIN huespedes h ON r.huesped_id = h.huesped_id;

-- Vista 2: Vista de quejas no resueltas
CREATE OR REPLACE VIEW vista_quejas_no_resueltas AS
SELECT 
    q.queja_id,
    h.nombre AS huesped,
    r.reserva_id,
    q.descripcion,
    q.fecha,
    q.estado,
    e.nombre AS empleado_responsable
FROM quejas q
JOIN reservas r ON q.reserva_id = r.reserva_id
JOIN huespedes h ON q.huesped_id = h.huesped_id
LEFT JOIN empleados e ON q.empleado_id = e.empleado_id
WHERE q.estado <> 'resuelta';


-- Vista 3: Vista procedencias del año 2025
CREATE OR REPLACE VIEW vista_procedencias_durante_2025 AS
SELECT
    p.procedencia_id,
    p.descripcion AS procedencia,
    COUNT(r.reserva_id) AS total_reservas,
    ROUND(
        COUNT(r.reserva_id) / 
        (SELECT COUNT(reserva_id) 
         FROM reservas 
         WHERE YEAR(fecha_entrada) = 2025) * 100, 
    2
    ) AS porcentaje
FROM huespedes h
JOIN procedencias p ON h.procedencia_id = p.procedencia_id
JOIN reservas r ON h.huesped_id = r.huesped_id
WHERE YEAR(r.fecha_entrada) = 2025
GROUP BY p.procedencia_id, p.descripcion
ORDER BY porcentaje DESC;

-- Vista 4: Vista historial de reserva por habitacion
CREATE OR REPLACE VIEW vista_historial_reservas_habitaciones AS
SELECT
    h.numero AS habitacion,
    th.nombre AS tipo_habitacion,
    h.estado,
    r.reserva_id,
    CONCAT(huespedes.nombre, ' (', huespedes.documento, ')') AS huesped,
    r.fecha_entrada,
    r.fecha_salida
FROM habitaciones h
LEFT JOIN tipos_habitacion th ON h.tipo_id = th.tipo_id
LEFT JOIN reservas r ON h.habitacion_id = r.habitacion_id
LEFT JOIN huespedes ON r.huesped_id = huespedes.huesped_id
ORDER BY h.numero;


-- Vista 5: Vista  duración de la estadía por canal de reserva 
CREATE OR REPLACE VIEW vista_duracion_canal AS
SELECT
    c.canal_id, 
    c.nombre AS canal,
    YEAR(r.fecha_entrada) AS anio,
    COUNT(r.reserva_id) AS total_reservas,
    ROUND(AVG(DATEDIFF(r.fecha_salida, r.fecha_entrada)),2) AS duracion_promedio
FROM reservas r
JOIN canales_reserva c ON r.canal_id = c.canal_id
GROUP BY c.canal_id, c.nombre, YEAR(r.fecha_entrada);



-- ======================================
-- FUNCIONES PERSONALIZADAS
-- ======================================

-- Función1: calcular noches

DELIMITER //

CREATE FUNCTION calcular_noches(fecha_in DATE, fecha_out DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(fecha_out, fecha_in);
END //

DELIMITER ;

-- Función2: total_consumo

DELIMITER //

CREATE FUNCTION total_consumo(p_huesped_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(s.precio * rs.cantidad)
    INTO total
    FROM reserva_servicio rs
    JOIN reservas r ON rs.reserva_id = r.reserva_id
    JOIN servicios s ON rs.servicio_id = s.servicio_id
    WHERE r.huesped_id = p_huesped_id;

    RETURN IFNULL(total,0);
END //

DELIMITER ;



-- ======================================
-- STORED PROCEDURES
-- ======================================

-- SP 1:
DELIMITER //

CREATE PROCEDURE calcular_estado_reserva_final(IN p_reserva_id INT)
BEGIN

DECLARE v_precio_habitacion DECIMAL(10,2);
DECLARE v_total_habitacion DECIMAL(10,2);
DECLARE v_total_servicios DECIMAL(10,2);
DECLARE v_total_pagos DECIMAL(10,2);
DECLARE v_descuento DECIMAL(10,2) DEFAULT 0;
DECLARE v_origen_descuento VARCHAR(100) DEFAULT 'Sin descuento';
DECLARE v_total DECIMAL(10,2);

DECLARE v_noches INT;
DECLARE v_fecha_in DATE;
DECLARE v_fecha_out DATE;

DECLARE v_promocion DECIMAL(5,2);
DECLARE v_nombre_promo VARCHAR(100);

DECLARE v_metodo_transferencia INT DEFAULT 0;

-- 1 Obtener precio y fechas

SELECT h.precio, r.fecha_entrada, r.fecha_salida
INTO v_precio_habitacion, v_fecha_in, v_fecha_out
FROM reservas r
JOIN habitaciones h 
ON r.habitacion_id = h.habitacion_id
WHERE r.reserva_id = p_reserva_id;

-- 2 Calcular noches usando funcion calcular_noches

SET v_noches = calcular_noches(v_fecha_in, v_fecha_out);

-- 3 Total habitación

SET v_total_habitacion = v_precio_habitacion * v_noches;

-- 4 Calcular servicios

SELECT IFNULL(SUM(s.precio * rs.cantidad),0)
INTO v_total_servicios
FROM reserva_servicio rs
JOIN servicios s 
ON rs.servicio_id = s.servicio_id
WHERE rs.reserva_id = p_reserva_id;

-- 5 Buscar promoción activa : promo verano, promo invierno

SELECT p.descuento_porcentaje, p.nombre
INTO v_promocion, v_nombre_promo
FROM reservas r
JOIN promociones p 
ON r.promocion_id = p.promocion_id
WHERE r.reserva_id = p_reserva_id
AND p.activa = TRUE
AND CURDATE() BETWEEN p.fecha_inicio AND p.fecha_fin;

-- 6 Calcular pagos

SELECT IFNULL(SUM(monto),0)
INTO v_total_pagos
FROM pagos
WHERE reserva_id = p_reserva_id;

-- 7 Verificar si hubo pago por transferencia para aplicar descuento

SELECT COUNT(*)
INTO v_metodo_transferencia
FROM pagos
WHERE reserva_id = p_reserva_id
AND metodo_id = 1;

-- 8 Aplicar descuentos (NO acumulativos)

IF v_promocion IS NOT NULL THEN

    SET v_descuento = (v_total_habitacion * v_promocion)/100;
    SET v_origen_descuento = CONCAT(v_nombre_promo,' (',v_promocion,'%)');

ELSEIF v_metodo_transferencia > 0 THEN

    SET v_descuento = v_total_habitacion * 0.10;
    SET v_origen_descuento = 'Descuento 10% por transferencia';

END IF;

-- 9 Total final

SET v_total = v_total_habitacion + v_total_servicios - v_descuento;

-- 10 Resultado descripcion consumo

SELECT 

p_reserva_id AS Reserva,

v_noches AS Noches,

v_precio_habitacion AS Precio_por_noche,

v_total_habitacion AS Total_Habitacion,

v_total_servicios AS Servicios,

v_descuento AS Descuento,

v_origen_descuento AS Origen_Descuento,

v_total_pagos AS Pagos,

v_total AS Total_Final,

CASE 

WHEN v_total_pagos < v_total
THEN CONCAT('Deuda pendiente: $', FORMAT(v_total - v_total_pagos,2))

WHEN v_total_pagos > v_total
THEN CONCAT('Saldo a favor del huésped: $', FORMAT(v_total_pagos - v_total,2))

ELSE
'Reserva paga'

END AS Estado;

END //

DELIMITER ;



-- SP 2:Buscar habitaciones disponibles por fechas
DELIMITER $$

CREATE PROCEDURE sp_buscar_habitaciones_disponibles(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    OUT p_mensaje VARCHAR(200)
)
BEGIN

    DECLARE cantidad INT;

    /* =========================
       1. Mostrar habitaciones disponibles
       ========================= */

    SELECT h.habitacion_id, h.numero, th.nombre AS tipo, h.precio
    FROM habitaciones h
    JOIN tipos_habitacion th 
        ON th.tipo_id = h.tipo_id
    WHERE h.estado = 'disponible'
    AND h.habitacion_id NOT IN (
        SELECT habitacion_id
        FROM reservas
        WHERE NOT (
            fecha_salida <= p_fecha_inicio
            OR fecha_entrada >= p_fecha_fin
        )
    );

    /* =========================
       2. Contar EXACTAMENTE las mismas habitaciones
       ========================= */

    SELECT COUNT(*) INTO cantidad
    FROM habitaciones h
    WHERE h.estado = 'disponible'
    AND h.habitacion_id NOT IN (
        SELECT habitacion_id
        FROM reservas
        WHERE NOT (
            fecha_salida <= p_fecha_inicio
            OR fecha_entrada >= p_fecha_fin
        )
    );

    /* =========================
       3. Mensaje automático
       ========================= */

    IF cantidad = 0 THEN
        SET p_mensaje =
            'No hay habitaciones disponibles en esas fechas';
    ELSE
        SET p_mensaje =
            CONCAT('Busqueda exitosa. Habitaciones disponibles: ', cantidad);
    END IF;

END$$

DELIMITER ;


-- ======================================
-- TRIGGERS
-- ======================================
-- Trigger 1:
DELIMITER $$

CREATE TRIGGER trg_before_insert_reserva_definitivo
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    DECLARE estado_habitacion VARCHAR(20);
    DECLARE cantidad_superposiciones INT;

    -- Validar fechas
    IF NEW.fecha_salida <= NEW.fecha_entrada THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de salida debe ser posterior a la fecha de entrada';
    END IF;

    -- Obtener estado de la habitación
    SELECT estado
    INTO estado_habitacion
    FROM habitaciones
    WHERE habitacion_id = NEW.habitacion_id;

    -- Validar mantenimiento
    IF estado_habitacion = 'mantenimiento' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede reservar: Habitación en mantenimiento';
    END IF;

    -- Validar ocupada
    IF estado_habitacion = 'ocupada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede reservar: Habitación ocupada';
    END IF;

    -- Validar superposición de reservas
    SELECT COUNT(*) INTO cantidad_superposiciones
    FROM reservas
    WHERE habitacion_id = NEW.habitacion_id
      AND NEW.fecha_entrada < fecha_salida
      AND fecha_entrada < NEW.fecha_salida;

    IF cantidad_superposiciones > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede reservar: fechas superpuestas con otra reserva';
    END IF;

END$$

DELIMITER ;

-- Trigger 2:


DELIMITER $$

CREATE TRIGGER trg_after_insert_reserva_actualizar_habitacion
AFTER INSERT ON reservas
FOR EACH ROW
BEGIN

    UPDATE habitaciones
    SET estado = 'ocupada'
    WHERE habitacion_id = NEW.habitacion_id;

END$$

DELIMITER ;



