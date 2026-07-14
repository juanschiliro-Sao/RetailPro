--CREAR BASE DE DATOS

CREATE DATABASE Ventas_Tech_DB;

--CLAUSULA USE

Use Ventas_Tech_DB;

DROP TABLE IF EXISTS ventas; 
DROP TABLE IF EXISTS productos; 
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

--CREAR TABLA CATEGORIAS

CREATE TABLE categorias (
id_categoria int PRIMARY KEY ,
nombre_categoria VARCHAR(50) not null,
descripcion VARCHAR(200),
);

--CREAR TABLA CLIENTES

CREATE TABLE clientes (
id_cliente INT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
email VARCHAR(100) unique,
ciudad VARCHAR(50),
fecha_registro DATE NOT NULL,
);

--CREAR TABLA PRODUCTOS

CREATE TABLE productos (
id_producto INT PRIMARY KEY,
nombre_producto VARCHAR(100) NOT NULL,
id_categoria INT FOREIGN KEY REFERENCES categorias (id_categoria),
precio DECIMAL(10 ,2) NOT NULL,
stock INT DEFAULT 0,
activo BIT DEFAULT 1,
);

--CREAR TABLA VENTAS

CREATE TABLE ventas (
id_venta INT PRIMARY KEY,
id_cliente INT	FOREIGN KEY REFERENCES clientes (id_cliente),
id_producto INT FOREIGN KEY REFERENCES productos (id_producto),
cantidad INT NOT NULL,
precio_unitario DECIMAL (10,2) NOT NULL,
fecha_venta DATE NOT NULL,
);

--INSERT DATA, CARGAMOS REGISTROS EN CATEGORIAS

INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

--INSERT DATA, CARGAMOS REGISTROS EN CLIENTES

INSERT INTO clientes VALUES (1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05');
INSERT INTO clientes VALUES (2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10');
INSERT INTO clientes VALUES (3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01');
INSERT INTO clientes VALUES (4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15');
INSERT INTO clientes VALUES (5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');

--INSERT DATA, CARGAMOS REGISTROS EN PRODUCTOS

INSERT INTO productos VALUES (1, 'Laptop Pro 15',       1, 1200.00, 15, 1);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico',   2,   28.00, 80, 1);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"',      1,  450.00, 12, 1);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro',  3,  120.00, 35, 1);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB',     4,  130.00, 18, 1);
INSERT INTO productos VALUES (6, 'Teclado Mecánico',    2,   95.00, 40, 1);

--INSERT DATA, CARGAMOS REGISTROS EN VENTAS

INSERT INTO ventas VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas VALUES (2,  2, 2, 5,   28.00, '2024-03-06');
INSERT INTO ventas VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO ventas VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');

--CONFIRMACION DE LA CARGA DE TABLAS CORRECTAMENTE

SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;

--Consulta 1: Resumen ejecutivo mensual 

SELECT
DATEPART (MONTH, fecha_venta) AS Mes,	
SUM (cantidad * precio_unitario) AS Total_Facturado,
COUNT (cantidad) AS conteo,
AVG (precio_unitario) AS ticket_promedio

FROM
ventas

GROUP BY 

DATEPART (MONTH, fecha_venta);

--Consulta 2: Ranking de productos

SELECT TOP 5

id_producto AS codigo_del_producto,
SUM (cantidad) AS unidades_totales_vendidas,
SUM (cantidad * precio_unitario) AS Total_Facturado

FROM 
ventas
GROUP BY
id_producto
ORDER BY
Total_Facturado DESC;

--Consulta 3:  Clientes recurrentes 

SELECT
id_cliente AS Codigo_del_cliente,
COUNT(*) AS Cantidad_de_Pedidos,
SUM (cantidad * precio_unitario) AS Total_Facturado

FROM
ventas

GROUP BY
id_cliente

HAVING
 COUNT (*) > 1

 ORDER BY
 Total_Facturado DESC;

 --Consulta 4: Meses por encima/por debajo del promedio 

 SELECT 
    DATEPART(month, fecha_venta) AS Numero_Mes,
    SUM(cantidad * precio_unitario) AS Total_Facturado_Mensual,
    (
        SELECT AVG(TotalMensual) 
        FROM (
            SELECT SUM(cantidad * precio_unitario) AS TotalMensual 
            FROM ventas 
            GROUP BY DATEPART(month, fecha_venta)
        ) Sub
    ) AS Promedio_General_Mensual,
    CASE 
        WHEN SUM(cantidad * precio_unitario) > (
            SELECT AVG(TotalMensual) 
            FROM (
                SELECT SUM(cantidad * precio_unitario) AS TotalMensual 
                FROM ventas 
                GROUP BY DATEPART(month, fecha_venta)
            ) Sub
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS Estado_vs_Promedio
FROM 
    ventas
GROUP BY 
    DATEPART(month, fecha_venta)
ORDER BY 
    Numero_Mes ASC;


--BLOQUE DE CIERRE: HALLAZGOS DEL ANÁLISIS DE VENTAS
-- =========================================================================
-- 1. Se puede visualizar que el producto: Mouse Inalambrico es el producto mas vendido; asi como el Teclado Mecanico es el 2º con mas unidades vendidas. .
-- 2. El Mes 3 es el mes que mas facturo ya que vendio 10 unidades por un total de: $6444.00.
-- 3. Podemos ver que en cuanto a los clientes: Maria Lopez es la cliente que mas gasto, ya que realizo dos pedidos con un total de $2640; Laura Torres es la otra clienta que mas gasto con la misma cantidad de pedidos.































