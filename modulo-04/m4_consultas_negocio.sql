-- ============================================================================
-- PROYECTO: RetailPro (Ventas_Tech_DB)
-- MÓDULO 4: Pre-entrega - Consultas SQL de Negocio
-- ARCHIVO: m4_consultas_negocio.sql
-- DESCRIPCIÓN: Extracción de métricas clave con funciones de agregación,
--              agrupaciones (GROUP BY), filtros de grupos (HAVING) y CASE WHEN.
-- ============================================================================

-- ============================================================================
-- CONSULTA 1: Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes.
-- ============================================================================
SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    ROUND(AVG(cantidad * precio_unitario), 2) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes ASC;


-- ============================================================================
-- CONSULTA 2: Ranking de productos
-- Top 5 de id_producto por total facturado y unidades vendidas.
-- ============================================================================
SELECT 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;


-- ============================================================================
-- CONSULTA 3: Clientes recurrentes
-- Clientes con más de un pedido, volumen de transacciones y gasto total.
-- ============================================================================
SELECT 
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- ============================================================================
-- CONSULTA 4: Meses por encima / por debajo del promedio mensual general
-- Facturación mensual comparada frente al promedio mensual de la empresa.
-- ============================================================================
WITH facturacion_mensual AS (
    SELECT 
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_mes
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
),
promedio_general AS (
    SELECT AVG(total_mes) AS promedio_mensual
    FROM facturacion_mensual
)
SELECT 
    f.mes,
    f.total_mes AS total_facturado,
    CASE 
        WHEN f.total_mes >= p.promedio_mensual THEN 'Por encima'
        ELSE 'Por debajo'
    END AS rendimiento_vs_promedio
FROM facturacion_mensual f
CROSS JOIN promedio_general p
ORDER BY f.mes ASC;


-- ============================================================================
-- BLOQUE DE CIERRE: 3 HALLAZGOS CLAVE DE NEGOCIO
-- ============================================================================
/*
HALLAZGOS IDENTIFICADOS EN EL ANÁLISIS COMERCIAL:

1. Alta concentración de ingresos en hardware de alta gama (Efecto Pareto):
   El `id_producto = 1` (Laptop Pro 15) es el principal motor de facturación de 
   la empresa. Con únicamente 3 unidades vendidas entre las transacciones 1 y 7,
   generó $3,600.00 sobre un total comercializado de $5,654.00, representando
   aproximadamente el 63.7% de todos los ingresos del período analizado.

2. Alta tasa de recurrencia en la cartera de clientes:
   El 80% de los clientes registrados (4 de 5: id_cliente 1, 2, 3 y 4) han 
   concretado más de una compra (2 transacciones cada uno). En particular, el
   `id_cliente = 1` encabeza el volumen de compra con un desembolso acumulado de
   $2,640.00 al combinar adquisición de computadoras con accesorios de audio.

3. Disparidad entre rotación física y rentabilidad monetaria:
   Existe un contraste marcado entre el volumen de unidades vendidas y el total
   facturado. El `id_producto = 2` (Mouse Inalámbrico) lidera ampliamente el 
   volumen físico con 13 unidades despachadas, pero su aporte a los ingresos es 
   marginal ($364.00), lo que confirma que los periféricos cumplen una función
   de atracción y recurrencia, mientras que los equipos de cómputo sostienen el 
   volumen financiero del negocio.
*/
