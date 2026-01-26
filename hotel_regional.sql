-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS hotel_regional;
USE hotel_regional;
-- TABLAS
-- Creación tabla PROCEDENCIAS
CREATE TABLE procedencias (
    procedencia_id INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(30) NOT NULL UNIQUE
);

-- Creación tabla HUESPEDES
CREATE TABLE huespedes (
    huesped_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    documento VARCHAR(50),
    telefono VARCHAR(50),
    email VARCHAR(100),
    procedencia_id INT NOT NULL,
    FOREIGN KEY (procedencia_id) REFERENCES procedencias(procedencia_id)
);

-- Creación tabla TIPOS DE HABITACION
CREATE TABLE tipos_habitacion (
    tipo_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    capacidad INT NOT NULL
);

-- Creación tabla HABITACIONES
CREATE TABLE habitaciones (
    habitacion_id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) NOT NULL UNIQUE,
    tipo_id INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    estado ENUM('disponible','ocupada','mantenimiento') DEFAULT 'disponible',
    FOREIGN KEY (tipo_id) REFERENCES tipos_habitacion(tipo_id)
);

-- Creación tabla DEPARTAMENTOS
CREATE TABLE departamentos (
    departamento_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- Creación de tabla CARGOS
CREATE TABLE cargos (
    cargo_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    departamento_id INT NOT NULL,
    FOREIGN KEY (departamento_id) REFERENCES departamentos(departamento_id),
    UNIQUE (nombre, departamento_id)
);

-- Creación de tabla EMPLEADOS
CREATE TABLE empleados (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(50),
    cargo_id INT NOT NULL,
    FOREIGN KEY (cargo_id) REFERENCES cargos(cargo_id)
);

-- Creación de tabla PROMOCIONES
CREATE TABLE promociones (
    promocion_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descuento_porcentaje DECIMAL(5,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    activa BOOLEAN DEFAULT TRUE
);

-- Creación de tabla CANALES DE RESERVA
CREATE TABLE canales_reserva (
    canal_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);


-- Creación de tabla RESERVAS

CREATE TABLE reservas (
    reserva_id INT AUTO_INCREMENT PRIMARY KEY,
    huesped_id INT NOT NULL,
    habitacion_id INT NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    promocion_id INT,
    canal_id INT NOT NULL,
    empleado_checkin INT,
    empleado_checkout INT,

    FOREIGN KEY (huesped_id) REFERENCES huespedes(huesped_id),
    FOREIGN KEY (habitacion_id) REFERENCES habitaciones(habitacion_id),
    FOREIGN KEY (promocion_id) REFERENCES promociones(promocion_id),
    FOREIGN KEY (canal_id) REFERENCES canales_reserva(canal_id),
    FOREIGN KEY (empleado_checkin) REFERENCES empleados(empleado_id),
    FOREIGN KEY (empleado_checkout) REFERENCES empleados(empleado_id)
);


-- Creación de tabla SERVICIOS

CREATE TABLE servicios (
    servicio_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);


-- Creación de tabla RESERVA_SERVICIO
CREATE TABLE reserva_servicio (
    reserva_id INT NOT NULL,
    servicio_id INT NOT NULL,
    cantidad INT DEFAULT 1,
    PRIMARY KEY (reserva_id, servicio_id),
    FOREIGN KEY (reserva_id) REFERENCES reservas(reserva_id),
    FOREIGN KEY (servicio_id) REFERENCES servicios(servicio_id)
);

-- Creación de tabla METODOS DE PAGO

CREATE TABLE metodos_pago (
    metodo_id INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL UNIQUE
);


-- Creación de tabla PAGOS

CREATE TABLE pagos (
    pago_id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL,
    empleado_id INT NOT NULL,
    metodo_id INT NOT NULL,
    fecha DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (reserva_id) REFERENCES reservas(reserva_id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(empleado_id),
    FOREIGN KEY (metodo_id) REFERENCES metodos_pago(metodo_id)
);

-- Creación de tabla QUEJAS

CREATE TABLE quejas (
    queja_id INT AUTO_INCREMENT PRIMARY KEY,
    huesped_id INT NOT NULL,
    reserva_id INT NOT NULL,
    empleado_id INT,
    descripcion TEXT NOT NULL,
    fecha DATE NOT NULL,
    estado ENUM('pendiente','en proceso','resuelta') DEFAULT 'pendiente',

    FOREIGN KEY (huesped_id) REFERENCES huespedes(huesped_id),
    FOREIGN KEY (reserva_id) REFERENCES reservas(reserva_id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(empleado_id)
);
