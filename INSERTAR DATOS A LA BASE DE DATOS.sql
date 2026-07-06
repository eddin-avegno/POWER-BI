INSERT INTO Tipos_Licencia (tipo_licencia, descripcion) VALUES
('C', 'Licencia profesional para taxis convencionales, ejecutivos y camionetas livianas'),
('D', 'Licencia profesional para transporte de pasajeros'),
('E', 'Licencia profesional para transporte pesado');
GO
INSERT INTO Aspirantes 
(cedula, nombres, apellidos, genero, edad, ciudad_residencia, telefono, correo, fecha_registro)
VALUES
('1204567890', 'Carlos Andres', 'Vera Lopez', 'Masculino', 28, 'Babahoyo', '0981111111', 'carlosvera@gmail.com', '2026-01-05'),
('1209876543', 'Maria Fernanda', 'Ruiz Castro', 'Femenino', 31, 'Quevedo', '0982222222', 'mariaruiz@gmail.com', '2026-01-06'),
('1203456789', 'Luis Alberto', 'Mendoza Diaz', 'Masculino', 24, 'Vinces', '0983333333', 'luismendoza@gmail.com', '2026-01-07'),
('1206543210', 'Ana Gabriela', 'Torres Palma', 'Femenino', 26, 'Babahoyo', '0984444444', 'anatorres@gmail.com', '2026-01-08'),
('1201122334', 'Pedro Miguel', 'Cedeño Vera', 'Masculino', 35, 'Montalvo', '0985555555', 'pedrocedeno@gmail.com', '2026-01-09'),
('1209988776', 'Jose Daniel', 'Zambrano Ruiz', 'Masculino', 29, 'Babahoyo', '0986666666', 'josezambrano@gmail.com', '2026-01-10'),
('1202233445', 'Karla Beatriz', 'Mora Sanchez', 'Femenino', 22, 'Ventanas', '0987777777', 'karlamora@gmail.com', '2026-01-11'),
('1203344556', 'Andres David', 'Loor Cedeño', 'Masculino', 33, 'Quevedo', '0988888888', 'andresloor@gmail.com', '2026-01-12');
GO
INSERT INTO Cursos
(nombre_curso, id_tipo_licencia, modalidad, duracion_horas, periodo_academico, fecha_inicio, fecha_fin, cupo_maximo)
VALUES
('Curso Licencia Tipo C', 1, 'Semipresencial', 480, '2026-1', '2026-02-01', '2026-06-30', 40),
('Curso Licencia Tipo D', 2, 'Semipresencial', 520, '2026-1', '2026-02-01', '2026-07-15', 35),
('Curso Licencia Tipo E', 3, 'Presencial', 600, '2026-1', '2026-02-05', '2026-08-01', 30),
('Curso Licencia Tipo C Intensivo', 1, 'Presencial', 420, '2026-2', '2026-08-10', '2026-12-20', 35);
GO
INSERT INTO Instructores
(nombres, apellidos, especialidad)
VALUES
('Jorge Luis', 'Zambrano Vera', 'Legislacion de Transito'),
('Pedro Miguel', 'Cedeño Ruiz', 'Conduccion Practica'),
('Ana Maria', 'Torres Palma', 'Seguridad Vial'),
('Luis Enrique', 'Mora Sanchez', 'Mecanica Basica');
GO
INSERT INTO Matriculas
(id_aspirante, id_curso, fecha_matricula, estado_matricula, valor_matricula)
VALUES
(1, 1, '2026-01-10', 'Activa', 950.00),
(2, 1, '2026-01-12', 'Finalizada', 950.00),
(3, 2, '2026-01-15', 'Activa', 1100.00),
(4, 2, '2026-01-18', 'Retirada', 1100.00),
(5, 3, '2026-01-20', 'Activa', 1300.00),
(6, 3, '2026-01-22', 'Finalizada', 1300.00),
(7, 4, '2026-08-12', 'Activa', 950.00),
(8, 4, '2026-08-13', 'Activa', 950.00);
GO
INSERT INTO Clases
(id_curso, id_instructor, fecha_clase, tema_clase, tipo_clase, horas_clase)
VALUES
(1, 1, '2026-02-01', 'Ley de Transito', 'Teorica', 2),
(1, 3, '2026-02-02', 'Seguridad Vial', 'Virtual', 2),
(1, 2, '2026-02-03', 'Practica de Conduccion', 'Practica', 3),

(2, 1, '2026-02-04', 'Normativa de Transporte', 'Teorica', 2),
(2, 3, '2026-02-05', 'Educacion Vial Virtual', 'Virtual', 2),

(3, 4, '2026-02-06', 'Mecanica Basica', 'Teorica', 2),
(3, 2, '2026-02-07', 'Conduccion de Transporte Pesado', 'Practica', 3),

(4, 1, '2026-08-20', 'Reglamento General de Transito', 'Teorica', 2),
(4, 3, '2026-08-21', 'Seguridad Vial Virtual', 'Virtual', 2);
GO
INSERT INTO Asistencias
(id_matricula, id_clase, estado_asistencia, minutos_conectado)
VALUES
(1, 1, 'Presente', 0),
(1, 2, 'Presente', 90),
(1, 3, 'Ausente', 0),

(2, 1, 'Presente', 0),
(2, 2, 'Presente', 95),
(2, 3, 'Presente', 0),

(3, 4, 'Presente', 0),
(3, 5, 'Ausente', 0),

(4, 4, 'Ausente', 0),
(4, 5, 'Presente', 80),

(5, 6, 'Presente', 0),
(5, 7, 'Presente', 0),

(6, 6, 'Presente', 0),
(6, 7, 'Ausente', 0),

(7, 8, 'Presente', 0),
(7, 9, 'Presente', 85),

(8, 8, 'Presente', 0),
(8, 9, 'Ausente', 0);
GO
INSERT INTO Evaluaciones
(id_matricula, tipo_evaluacion, fecha_evaluacion, nota, estado_evaluacion)
VALUES
(1, 'Teorica', '2026-03-01', 8.50, 'Aprobado'),
(1, 'Practica', '2026-03-10', 7.80, 'Aprobado'),

(2, 'Teorica', '2026-03-01', 9.00, 'Aprobado'),
(2, 'Practica', '2026-03-10', 8.70, 'Aprobado'),

(3, 'Teorica', '2026-03-05', 6.50, 'Reprobado'),
(3, 'Practica', '2026-03-15', 7.20, 'Aprobado'),

(4, 'Teorica', '2026-03-05', 5.80, 'Reprobado'),

(5, 'Teorica', '2026-03-08', 8.20, 'Aprobado'),
(5, 'Practica', '2026-03-18', 8.90, 'Aprobado'),

(6, 'Teorica', '2026-03-08', 7.00, 'Aprobado'),
(6, 'Practica', '2026-03-18', 6.40, 'Reprobado'),

(7, 'Teorica', '2026-09-01', 8.00, 'Aprobado'),
(8, 'Teorica', '2026-09-01', 7.50, 'Aprobado');
GO
INSERT INTO Pagos
(id_matricula, fecha_pago, monto_pagado, metodo_pago, estado_pago)
VALUES
(1, '2026-01-10', 300.00, 'Efectivo', 'Parcial'),
(1, '2026-02-10', 300.00, 'Transferencia', 'Parcial'),

(2, '2026-01-12', 950.00, 'Transferencia', 'Pagado'),

(3, '2026-01-15', 500.00, 'Efectivo', 'Parcial'),
(3, '2026-02-15', 300.00, 'Efectivo', 'Parcial'),

(4, '2026-01-18', 200.00, 'Efectivo', 'Parcial'),

(5, '2026-01-20', 1300.00, 'Transferencia', 'Pagado'),

(6, '2026-01-22', 700.00, 'Efectivo', 'Parcial'),
(6, '2026-02-22', 600.00, 'Transferencia', 'Pagado'),

(7, '2026-08-12', 500.00, 'Efectivo', 'Parcial'),
(8, '2026-08-13', 950.00, 'Transferencia', 'Pagado');
GO


