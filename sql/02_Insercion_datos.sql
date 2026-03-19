-- 1 departamentos

INSERT INTO departamentos (nombre) VALUES
('Administración'),
('Recepción'),
('Limpieza'),
('Gastronomía'),
('Mantenimiento'),
('Turismo y Recreación'),
('Transporte'),
('Spa y Bienestar');

-- 2 tipos_habitacion

INSERT INTO tipos_habitacion (nombre, descripcion, capacidad) VALUES
('Single', 'Habitación individual estándar', 1),
('Doble', 'Habitación doble estándar', 2),
('Triple', 'Habitación triple familiar', 3),
('Suite Junior', 'Suite con sala de estar', 2),
('Suite Ejecutiva', 'Suite premium con vista', 2);


-- 3 canales de reserva
INSERT INTO canales_reserva (nombre) VALUES
('Sitio Web'),
('Booking'),
('Recepción Presencial'),
('Teléfono'),
('Agencia de Viajes');

-- 4 metodos de pago
INSERT INTO metodos_pago (descripcion) VALUES
('Transferencia Bancaria'),
('Tarjeta Credito'),
('Tarjeta Debito'),
('Efectivo');


-- 5 promociones
INSERT INTO promociones (nombre, descuento_porcentaje, fecha_inicio, fecha_fin, activa) VALUES
('Promo Invierno 2025', 15.00, '2025-06-01', '2025-08-31', TRUE),
('Promo Verano 2026', 10.00, '2026-01-01', '2026-03-31', TRUE);

-- 6 cargos
INSERT INTO cargos (nombre, departamento_id) VALUES
('Gerente General', 1),
('Administrativo', 1),
('Jefe de Recepción', 2),
('Recepcionista', 2),
('Jefa de Housekeeping', 3),
('Mucama', 3),
('Chef Ejecutivo', 4),
('Cocinero', 4),
('Mozo', 4),
('Jefe de Mantenimiento', 5),
('Técnico de Mantenimiento', 5),
('Guía Turístico', 6),
('Traductor', 6),
('Profesor de Baile', 6),
('Agente de Excursiones', 6),
('Chofer', 7),
('Masajista', 8);



-- 7 empleados

INSERT INTO empleados (nombre, telefono, cargo_id) VALUES
('Laura Martinez', '3874000001', 1),
('Carlos Gomez', '3874000002', 2),
('Marina Lopez', '3874008002', 2),
('Sofia Diaz', '3874000003', 3),
('Luciano Perez', '3874000004', 4),
('Valentina Torres', '3874000005', 4),
('Camila Romero', '3874003005', 4),
('Franco Herrera', '3874700005', 4),
('Mateo Sanchez', '3874700605', 4),
('Sebastian Gutierrez', '3874708605', 4),
('Daniel Carrizo', '3874708205', 4),
('Daniela Villanueva', '3874508205', 4),
('Lorenzo Carrizo', '3874758205', 4),
('Ana Suarez', '3874000006', 5),
('Rosa Mendez', '3874000007', 6),
('Marta Vega', '3874080007', 6),
('Elena Castro', '3874000007', 6),
('Patricia Ortiz', '3874400007', 6),
('Daniela Luna', '3874000007', 6),
('Noelia Godoy', '3874009007', 6),
('Silvia Ramirez', '3874220007', 6),
('Yesica Montoya', '3874220207', 6),
('Carla Florez', '3874000007', 6),
('Julieta Paz', '3874000007', 6),
('Rocio Benitez', '3874000007', 6),
('Natalia Acosta', '3874000074', 6),
('Romina Castillo', '3874003007', 6),
('Tomas Ledesma', '3874023007', 6),
('Ana Lopez', '3874176007', 6),
('Diego Alvarez', '3874000008', 7),
('Federico Morales', '3874000009', 8),
('Lucia Silva', '3874000010', 9),
('Brenda Navarro', '3874000010', 9),
('Cecilia Herrero', '3874020010', 9),
('Agustin Campos', '3874000010', 9),
('Milagros Reyes', '3874000010', 9),
('Jorge Villalba', '3874000011', 10),
('Pablo Correa', '3874000012', 11),
('Ricardo Funes', '3874040012', 11),
('Esteban Aguilar', '3874300012', 11),
('Emilio Ojeda', '3874300012', 11),
('Karina Aguilar', '3874390019', 11),
('Guillermo Salas', '3874000013', 12),
('Florencia Valdez', '3874500013', 12),
('Isabella Conti', '3874000014', 13),
('Aldana Ponce', '3874000015', 14),
('Lucas Sosa', '3874000016', 15),
('Camilo Arias', '3874050016', 15),
('Miguel Herrera', '3874300017', 16),
('Roberto Molina', '3874065015', 16),
('Javier Roldan', '3874800019', 16),
('Cristina Vargas', '3874050018', 16),
('Kevin Arce', '3874050014', 16),
('Carolina Mendez', '3874000018', 17),
('Luciana Peralta', '3874003018', 17),
('Paula Rojas', '3874300018', 17),
('Andrea Bravo', '3875000018', 17),
('Melina Bravo', '3872300018', 17),
('Sandra Quiroga', '38740670018', 17),
('Carolina Luna', '3874800018', 17),
('Gabriela Serrano', '3874800318', 17);

INSERT INTO procedencias (descripcion) VALUES
('Argentina'),
('Chile'),
('Uruguay'),
('Brasil'),
('Espana'),
('Italia'),
('Francia'),
('Alemania'),
('Estados Unidos'),
('Canada'),
('Mexico'),
('Peru'),
('Colombia'),
('Paraguay'),
('Bolivia'),
('Ecuador'),
('Venezuela'),
('Panama'),
('Costa Rica'),
('Guatemala'),
('El Salvador'),
('Honduras'),
('Nicaragua'),
('Republica Dominicana'),
('Cuba'),
('Reino Unido'),
('Irlanda'),
('Portugal'),
('Paises Bajos'),
('Belgica'),
('Suiza'),
('Austria'),
('Suecia'),
('Noruega'),
('Dinamarca'),
('Finlandia'),
('Polonia'),
('Republica Checa'),
('Hungria'),
('Rumania'),
('Grecia'),
('Turquia'),
('Rusia'),
('China'),
('Japon'),
('Corea del Sur'),
('Australia'),
('Nueva Zelanda'),
('Sudafrica'),
('India');
-- 8 procedencias
-- 9 habitaciones
-- 10 servicios
-- 11 huespedes
-- 12 reservas
-- 13 reserva_servicio
-- 14 pagos
-- 15 quejas