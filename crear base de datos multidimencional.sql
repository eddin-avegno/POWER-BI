/* ============================================================
   CREACIÓN DEL DATA WAREHOUSE
   Proyecto: Gestión Académica - Sindicato de Choferes
   Origen: BD_Sindicato_Choferes_Los_Rios
   Destino: DW_Gestion_Academica
   ============================================================ */

CREATE DATABASE DW_Gestion_Academica;
GO

USE DW_Gestion_Academica;
GO

/* ============================================================
   DIMENSIÓN TIEMPO
   Perspectiva: Tiempo
   Campos desde el OLTP:
   - periodo_academico: Cursos
   - fecha_matricula: Matriculas
   - fecha_pago: Pagos
   - fecha_evaluacion: Evaluaciones
   - fecha_clase: Clases
   ============================================================ */

CREATE TABLE Dim_Tiempo (
    pk_tiempo INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NULL,
    anio INT NULL,
    trimestre INT NULL,
    mes INT NULL,
    dia INT NULL,
    periodo_academico VARCHAR(20) NULL
);
GO

/* ============================================================
   DIMENSIÓN ASPIRANTE
   Perspectiva: Aspirante
   Origen: Aspirantes
   ============================================================ */

CREATE TABLE Dim_Aspirante (
    pk_aspirante INT IDENTITY(1,1) PRIMARY KEY,
    id_aspirante_origen INT NOT NULL,
    genero VARCHAR(20) NOT NULL,
    edad INT NOT NULL,
    ciudad_residencia VARCHAR(100) NOT NULL
);
GO

/* ============================================================
   DIMENSIÓN TIPO DE LICENCIA
   Perspectiva: Tipo de Licencia
   Origen: Tipos_Licencia
   ============================================================ */

CREATE TABLE Dim_Tipo_Licencia (
    pk_tipo_licencia INT IDENTITY(1,1) PRIMARY KEY,
    id_tipo_licencia_origen INT NOT NULL,
    tipo_licencia VARCHAR(10) NOT NULL,
    descripcion VARCHAR(200) NOT NULL
);
GO

/* ============================================================
   DIMENSIÓN CURSO
   Perspectiva: Curso
   Origen: Cursos
   ============================================================ */

CREATE TABLE Dim_Curso (
    pk_curso INT IDENTITY(1,1) PRIMARY KEY,
    id_curso_origen INT NOT NULL,
    nombre_curso VARCHAR(100) NOT NULL,
    modalidad VARCHAR(30) NOT NULL,
    duracion_horas INT NOT NULL,
    cupo_maximo INT NOT NULL
);
GO

/* ============================================================
   DIMENSIÓN ESTADO
   Perspectiva: Estado
   Origen:
   - Matriculas.estado_matricula
   - Pagos.estado_pago
   - Evaluaciones.estado_evaluacion
   - Asistencias.estado_asistencia
   ============================================================ */

CREATE TABLE Dim_Estado (
    pk_estado INT IDENTITY(1,1) PRIMARY KEY,
    estado_matricula VARCHAR(30) NULL,
    estado_pago VARCHAR(20) NULL,
    estado_evaluacion VARCHAR(20) NULL,
    estado_asistencia VARCHAR(20) NULL
);
GO

/* ============================================================
   DIMENSIÓN DOCENCIA
   Perspectiva: Docencia
   Origen:
   - Instructores
   - Clases.tipo_clase
   ============================================================ */

CREATE TABLE Dim_Docencia (
    pk_docencia INT IDENTITY(1,1) PRIMARY KEY,
    id_instructor_origen INT NULL,
    nombres VARCHAR(100) NULL,
    apellidos VARCHAR(100) NULL,
    especialidad VARCHAR(100) NULL,
    tipo_clase VARCHAR(30) NULL
);
GO

/* ============================================================
   TABLA DE HECHOS
   Relación central:
   Gestión Académica / Formación de Aspirantes
   ============================================================ */

CREATE TABLE Fact_Gestion_Academica (
    pk_fact_gestion INT IDENTITY(1,1) PRIMARY KEY,

    -- CLAVES FORÁNEAS HACIA LAS DIMENSIONES
    pk_tiempo INT NOT NULL,
    pk_aspirante INT NULL,
    pk_tipo_licencia INT NULL,
    pk_curso INT NULL,
    pk_estado INT NULL,
    pk_docencia INT NULL,

    -- INDICADORES DEL MODELO CONCEPTUAL AMPLIADO
    total_aspirantes_matriculados INT NULL,
    total_matriculas INT NULL,
    total_ingresos_pagados DECIMAL(10,2) NULL,
    promedio_valores DECIMAL(10,2) NULL,
    porcentaje_academico DECIMAL(10,2) NULL,
    total_clases_dictadas INT NULL,

    -- RELACIONES CON DIMENSIONES
    CONSTRAINT FK_Fact_Dim_Tiempo
        FOREIGN KEY (pk_tiempo)
        REFERENCES Dim_Tiempo(pk_tiempo),

    CONSTRAINT FK_Fact_Dim_Aspirante
        FOREIGN KEY (pk_aspirante)
        REFERENCES Dim_Aspirante(pk_aspirante),

    CONSTRAINT FK_Fact_Dim_Tipo_Licencia
        FOREIGN KEY (pk_tipo_licencia)
        REFERENCES Dim_Tipo_Licencia(pk_tipo_licencia),

    CONSTRAINT FK_Fact_Dim_Curso
        FOREIGN KEY (pk_curso)
        REFERENCES Dim_Curso(pk_curso),

    CONSTRAINT FK_Fact_Dim_Estado
        FOREIGN KEY (pk_estado)
        REFERENCES Dim_Estado(pk_estado),

    CONSTRAINT FK_Fact_Dim_Docencia
        FOREIGN KEY (pk_docencia)
        REFERENCES Dim_Docencia(pk_docencia)
);
GO