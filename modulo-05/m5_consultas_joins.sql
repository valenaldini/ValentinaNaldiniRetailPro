-- ============================================================================
-- PROYECTO: RetailPro (Ventas_Tech_DB)
-- MÓDULO 5: Pre-entrega - Consultas con JOINs para el proyecto
-- ARCHIVO: m5_consultas_joins.sql
-- DESCRIPCIÓN: Consultas relacionales (INNER JOIN, LEFT JOIN) y uniones 
--              (UNION ALL) para enriquecimiento y análisis de negocio.
-- ============================================================================


-- ============================================================================
-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- Propósito: Consolidar en una única vista analítica las ventas transaccionales
--            junto a las descripciones maestras de clientes, productos y familias
--            de categorías, sirviendo como fuente primaria para Power BI.
-- ============================================================================
SELECT 
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad AS ciudad_cliente,
    c.segmento AS segmento_cliente,
    p.id_producto,
    p.nombre AS nombre_producto,
    cat.nombre AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta ASC;

-- Hallazgo: Se integraron exitosamente el 100% de las 10 transacciones con sus 
-- atributos de cliente, categoría y producto, permitiendo cortes analíticos por 
-- geografía (ciudades principales) y por tipo de cliente (Corporativo vs. Minorista).


-- ============================================================================
-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: Detectar clientes registrados en la base de datos que todavía no han
--            realizado ninguna compra en la plataforma, para que CRM accione con
--            campañas de bienvenida o cupones de primera compra.
-- ============================================================================
SELECT 
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.ciudad,
    c.segmento
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: En la muestra actual, todos los clientes registrados presentan al menos
-- 1 compra asociada (0 registros devueltos); en producción, este filtro aísla los 
-- leads fríos para que CRM envíe incentivos de conversión antes de que abandonen el funnel.


-- ============================================================================
-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- Propósito: Identificar artículos del catálogo activo que no tienen ninguna venta
--            registrada, permitiendo al área de Producto revisar precios fuera de
--            mercado, falta de visibilidad o descontinuar stock inmovilizado.
-- ============================================================================
SELECT 
    p.id_producto,
    p.nombre AS nombre_producto,
    cat.nombre AS categoria,
    p.precio,
    p.costo
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: El catálogo completo registra rotación en el período de prueba analizado;
-- ante catálogos extensos, esta consulta detecta artículos con costo financiero de 
-- almacenamiento para aplicar promociones agresivas de liquidación o desliste.


-- ============================================================================
-- CONSULTA 4: Consolidado por canal (UNION ALL)
-- Propósito: Simular la distribución multicanal de ingresos agregando una etiqueta
--            literal ('Online' vs 'Presencial') según la temporalidad de la venta,
--            apilando los registros mediante UNION ALL y totalizando por canal.
-- ============================================================================
SELECT 
    canal,
    COUNT(*) AS total_operaciones,
    SUM(total) AS total_facturado_canal
FROM (
    -- Subconjunto 1: Ventas del primer bimestre clasificadas como canal Online
    SELECT 
        id_venta,
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Online' AS canal
    FROM ventas
    WHERE fecha_venta < '2024-03-01'

    UNION ALL

    -- Subconjunto 2: Ventas a partir de marzo clasificadas como canal Presencial
    SELECT 
        id_venta,
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-01'
) AS consolidado_canales
GROUP BY canal
ORDER BY total_facturado_canal DESC;

-- Hallazgo: El canal Presencial lidera la facturación acumulada impulsado por compras 
-- corporativas de hardware en marzo, mientras que el canal Online concentra transacciones 
-- recurrentes de menor ticket promedio en los dos primeros meses del año.
