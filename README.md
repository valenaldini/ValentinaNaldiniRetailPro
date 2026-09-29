# RetailPro - Proyecto Integral de Datos
Repositorio central del proyecto **RetailPro**, desarrollado para la certificación de **Data Analyst**. En este repositorio se integran el modelado de datos relacional, la ingeniería de datos en SQL, las consultas de analítica de negocio y la posterior conexión hacia herramientas de Business Intelligence (Power BI).
---
## 📁 Estructura del Repositorio
```text
ValentinaNaldiniRetailPro/
├── README.md
├── modulo-03/
│   └── ventas_tech_db.sql       # Script DDL/DML: Creación, restricciones y carga de datos
└── modulo-04/
    └── m4_consultas_negocio.sql # Consultas SQL: Métricas de negocio, agregaciones y rankings

🛠️ Módulo 3: Base de Datos Ventas_Tech_DB
Descripción
Implementación de la arquitectura relacional normalizada hasta Tercera Forma Normal (3NF) para la cadena TechStore / RetailPro. El modelo consta de 3 tablas de dimensión (categorias, clientes, productos) y 1 tabla de hechos (ventas).
Características del Script (ventas_tech_db.sql):
Idempotencia: Incluye bloque DROP TABLE IF EXISTS en orden inverso a las dependencias de claves foráneas, permitiendo ejecuciones repetibles sin errores de integridad referencial.
Integridad y restricciones: Definición explícita de PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE y valores DEFAULT.
Precisión financiera: Uso estricto de tipos DECIMAL(10,2) para precios y montos facturados, evitando pérdidas de precisión por redondeo flotante.
Carga de datos: Inserción explícita de 25 registros maestros y transaccionales para pruebas.

🚀 Instrucciones de Ejecución
Abrir SQL Server Management Studio (SSMS), pgAdmin (PostgreSQL) o la herramienta de gestión de bases de datos preferida.
Conectarse a la instancia del servidor local.
Abrir el archivo modulo-03/ventas_tech_db.sql.
Ejecutar el script completo (F5 en SSMS).
Las consultas de validación al final del script deben retornar:
categorias: 4 filas
clientes: 5 filas
productos: 6 filas
ventas: 10 filas

📊 Módulo 4: Consultas de Analítica de Negocio (m4_consultas_negocio.sql)
Descripción
Extracción y agregación de métricas comerciales clave directamente desde la tabla de hechos ventas para responder a preguntas de negocio:
Resumen ejecutivo mensual: Facturación total, volumen de pedidos y ticket promedio por mes.
Ranking de productos: Top 5 de productos por volumen facturado y unidades vendidas.
Fidelidad y recurrencia: Identificación de clientes con más de un pedido (HAVING COUNT(*) > 1) y total invertido.
Desempeño mensual: Comparativa del rendimiento mensual contra la media histórica mediante CTEs y lógica condicional (CASE WHEN).
Hallazgos analíticos: Conclusiones estratégicas sobre concentración de facturación (Efecto Pareto) y rotación de catálogo.

👩‍‍💻 Autora
Valentina Naldini - Data Analyst
