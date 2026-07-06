/*  Primero se elimina la tabla de hechos porque contiene claves
   foráneas hacia las dimensiones. Luego se eliminan las dimensiones.
   Este orden evita conflictos por relaciones entre tablas. */

USE DW_Gestion_Academica;


    /* ============================================================
       1. LIMPIEZA DE LA TABLA DE HECHOS
       ============================================================ */
    DELETE FROM dbo.Fact_Gestion_Academica;
    DBCC CHECKIDENT ('dbo.Fact_Gestion_Academica', RESEED, 0) WITH NO_INFOMSGS;

    /* ============================================================
       2. LIMPIEZA DE DIMENSIONES
       ============================================================ */  

    DELETE FROM dbo.Dim_Tiempo;
    DBCC CHECKIDENT ('dbo.Dim_Tiempo', RESEED, 0) WITH NO_INFOMSGS;


    DELETE FROM dbo.Dim_Aspirante;
    DBCC CHECKIDENT ('dbo.Dim_Aspirante', RESEED, 0) WITH NO_INFOMSGS;


    DELETE FROM dbo.Dim_Tipo_Licencia;
    DBCC CHECKIDENT ('dbo.Dim_Tipo_Licencia', RESEED, 0) WITH NO_INFOMSGS;


    DELETE FROM dbo.Dim_Curso;
    DBCC CHECKIDENT ('dbo.Dim_Curso', RESEED, 0) WITH NO_INFOMSGS;


    DELETE FROM dbo.Dim_Estado;
    DBCC CHECKIDENT ('dbo.Dim_Estado', RESEED, 0) WITH NO_INFOMSGS;


    DELETE FROM dbo.Dim_Docencia;
    DBCC CHECKIDENT ('dbo.Dim_Docencia', RESEED, 0) WITH NO_INFOMSGS;


    /* ============================================================
       3. CARGA DE DIMENSION TIEMPO       
       Cargar las fechas de inicio de los cursos y descomponerlas en
       año, trimestre, mes y día. También se guarda el periodo
       académico para realizar análisis por ciclo académico.
       ============================================================ */
           
    SELECT
        c.fecha_inicio AS fecha,
        DATEPART(YEAR, c.fecha_inicio) AS anio,
        DATEPART(QUARTER, c.fecha_inicio) AS trimestre,
        DATEPART(MONTH, c.fecha_inicio) AS mes,
        DATEPART(DAY, c.fecha_inicio) AS dia,
        c.periodo_academico
    FROM BD_Sindicato_Choferes_Los_Rios.dbo.Cursos c
    GROUP BY
        c.fecha_inicio,c.periodo_academico;
    /* ============================================================
       4. CARGA DE DIMENSION TIPO DE LICENCIA
       Cargar los tipos de licencia que oferta el sindicato.
       Esta dimensión permite analizar matrículas, ingresos y
       resultados académicos por tipo de licencia.
       ============================================================ */
    SELECT
        tl.id_tipo_licencia AS id_tipo_licencia_origen,
        tl.tipo_licencia,
        tl.descripcion
    FROM BD_Sindicato_Choferes_Los_Rios.dbo.Tipos_Licencia tl;

    /* ============================================================
       5. CARGA DE DIMENSION CURSO
       Cargar los datos descriptivos de los cursos académicos.
       Esta dimensión permite analizar los indicadores por curso,
       modalidad, duración y cupo máximo.
       ============================================================ */
    SELECT
        c.id_curso AS id_curso_origen,
        c.nombre_curso,
        c.modalidad,
        c.duracion_horas,
        c.cupo_maximo
    FROM BD_Sindicato_Choferes_Los_Rios.dbo.Cursos c;


    /* ============================================================
       6. CARGA DE DIMENSION ASPIRANTE
       Cargar los datos principales de los aspirantes.
       Esta dimensión permite analizar la información por género,
       edad y ciudad de residencia.
       ============================================================ */
    SELECT
        a.id_aspirante AS id_aspirante_origen,
        a.genero,
        a.edad,
        a.ciudad_residencia
    FROM BD_Sindicato_Choferes_Los_Rios.dbo.Aspirantes a;


    /* ============================================================
       7. CARGA DE DIMENSION ESTADO
       Consolidar los estados relacionados con el proceso académico:
       - Estado de matrícula
       - Estado de pago
       - Estado de evaluación
       - Estado de asistencia

       Se utiliza GROUP BY para evitar que se carguen combinaciones
       repetidas de estados.
       ============================================================ */
    SELECT
        m.estado_matricula,
        p.estado_pago,
        e.estado_evaluacion,
        a.estado_asistencia
    FROM BD_Sindicato_Choferes_Los_Rios.dbo.Matriculas m
    INNER JOIN BD_Sindicato_Choferes_Los_Rios.dbo.Pagos p
        ON m.id_matricula = p.id_matricula
    INNER JOIN BD_Sindicato_Choferes_Los_Rios.dbo.Evaluaciones e
        ON m.id_matricula = e.id_matricula
    INNER JOIN BD_Sindicato_Choferes_Los_Rios.dbo.Asistencias a
        ON m.id_matricula = a.id_matricula
    GROUP BY
        m.estado_matricula,
        p.estado_pago,
        e.estado_evaluacion,
        a.estado_asistencia;


    /* ============================================================
       8. CARGA DE DIMENSION DOCENCIA
       Cargar los instructores junto con el tipo de clase que dictan.
       Esta dimensión permite analizar clases dictadas por instructor,
       especialidad y tipo de clase.
       ============================================================ */
    SELECT
        i.id_instructor AS id_instructor_origen,
        i.nombres,
        i.apellidos,
        i.especialidad,
        c.tipo_clase
    FROM BD_Sindicato_Choferes_Los_Rios.dbo.Instructores i
    INNER JOIN BD_Sindicato_Choferes_Los_Rios.dbo.Clases c
        ON i.id_instructor = c.id_instructor
    GROUP BY
        i.id_instructor,
        i.nombres,
        i.apellidos,
        i.especialidad,
        c.tipo_clase;


    /* ============================================================
       9. CARGA DE TABLA DE HECHOS
       Tabla destino: Fact_Gestion_Academica
       Cargar los indicadores principales del proceso académico y
       relacionarlos con las dimensiones del Data Warehouse.
       Indicadores cargados:
       - total_aspirantes_matriculados
       - total_matriculas
       - total_ingresos_pagados
       - promedio_valores
       - porcentaje_academico
       - total_clases_dictadas
       ============================================================ */
    SELECT
        dt.pk_tiempo,da.pk_aspirante,dtl.pk_tipo_licencia,
        dc.pk_curso,de.pk_estado,dd.pk_docencia,

        1 AS total_aspirantes_matriculados,
        1 AS total_matriculas,

        ISNULL(pg.total_ingresos_pagados, 0) AS total_ingresos_pagados,
        ISNULL(pg.promedio_valores, 0) AS promedio_valores,
        ISNULL(ev.porcentaje_academico, 0) AS porcentaje_academico,
        ISNULL(cl.total_clases_dictadas, 0) AS total_clases_dictadas

    FROM BD_Sindicato_Choferes_Los_Rios.dbo.Matriculas m

    INNER JOIN BD_Sindicato_Choferes_Los_Rios.dbo.Aspirantes a
        ON m.id_aspirante = a.id_aspirante

    INNER JOIN BD_Sindicato_Choferes_Los_Rios.dbo.Cursos c
        ON m.id_curso = c.id_curso

    INNER JOIN BD_Sindicato_Choferes_Los_Rios.dbo.Tipos_Licencia tl
        ON c.id_tipo_licencia = tl.id_tipo_licencia

    INNER JOIN
    (
        SELECT
            MIN(pk_tiempo) AS pk_tiempo,
            fecha,
            periodo_academico
        FROM dbo.Dim_Tiempo
        GROUP BY
            fecha,
            periodo_academico
    ) dt
        ON dt.fecha = c.fecha_inicio
       AND dt.periodo_academico = c.periodo_academico

    INNER JOIN
    (
        SELECT
            MIN(pk_aspirante) AS pk_aspirante,
            id_aspirante_origen
        FROM dbo.Dim_Aspirante
        GROUP BY
            id_aspirante_origen
    ) da
        ON da.id_aspirante_origen = a.id_aspirante

    INNER JOIN
    (
        SELECT
            MIN(pk_tipo_licencia) AS pk_tipo_licencia,
            id_tipo_licencia_origen
        FROM dbo.Dim_Tipo_Licencia
        GROUP BY
            id_tipo_licencia_origen
    ) dtl
        ON dtl.id_tipo_licencia_origen = tl.id_tipo_licencia

    INNER JOIN
    (
        SELECT
            MIN(pk_curso) AS pk_curso,
            id_curso_origen
        FROM dbo.Dim_Curso
        GROUP BY
            id_curso_origen
    ) dc
        ON dc.id_curso_origen = c.id_curso

    LEFT JOIN
    (
        SELECT
            id_matricula,
            SUM(monto_pagado) AS total_ingresos_pagados,
            AVG(monto_pagado) AS promedio_valores,
            MAX(estado_pago) AS estado_pago
        FROM BD_Sindicato_Choferes_Los_Rios.dbo.Pagos
        GROUP BY
            id_matricula
    ) pg
        ON pg.id_matricula = m.id_matricula

    LEFT JOIN
    (
        SELECT
            id_matricula,
            AVG(nota) AS porcentaje_academico,
            MAX(estado_evaluacion) AS estado_evaluacion
        FROM BD_Sindicato_Choferes_Los_Rios.dbo.Evaluaciones
        GROUP BY
            id_matricula
    ) ev
        ON ev.id_matricula = m.id_matricula

    LEFT JOIN
    (
        SELECT
            id_matricula,
            MAX(estado_asistencia) AS estado_asistencia
        FROM BD_Sindicato_Choferes_Los_Rios.dbo.Asistencias
        GROUP BY
            id_matricula
    ) asi
        ON asi.id_matricula = m.id_matricula

    LEFT JOIN
    (
        SELECT
            c1.id_curso,
            c1.id_instructor,
            c1.tipo_clase,
            x.total_clases_dictadas
        FROM BD_Sindicato_Choferes_Los_Rios.dbo.Clases c1
        INNER JOIN
        (
            SELECT
                id_curso,
                MIN(id_clase) AS id_clase,
                COUNT(*) AS total_clases_dictadas
            FROM BD_Sindicato_Choferes_Los_Rios.dbo.Clases
            GROUP BY
                id_curso
        ) x
            ON c1.id_clase = x.id_clase
    ) cl
        ON cl.id_curso = c.id_curso

    LEFT JOIN
    (
        SELECT
            MIN(pk_estado) AS pk_estado,
            estado_matricula,
            estado_pago,
            estado_evaluacion,
            estado_asistencia
        FROM dbo.Dim_Estado
        GROUP BY
            estado_matricula,
            estado_pago,
            estado_evaluacion,
            estado_asistencia
    ) de
        ON de.estado_matricula = m.estado_matricula
       AND ISNULL(de.estado_pago, '') = ISNULL(pg.estado_pago, '')
       AND ISNULL(de.estado_evaluacion, '') = ISNULL(ev.estado_evaluacion, '')
       AND ISNULL(de.estado_asistencia, '') = ISNULL(asi.estado_asistencia, '')

    LEFT JOIN
    (
        SELECT
            MIN(pk_docencia) AS pk_docencia,
            id_instructor_origen,
            tipo_clase
        FROM dbo.Dim_Docencia
        GROUP BY
            id_instructor_origen,
            tipo_clase
    ) dd
        ON dd.id_instructor_origen = cl.id_instructor
       AND dd.tipo_clase = cl.tipo_clase;
    
   