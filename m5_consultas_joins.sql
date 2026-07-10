--CREAR BASE DE DATOS

CREATE DATABASE Ventas_Tech_DB;

--CLAUSULA USE

Use Ventas_Tech_DB;

DROP TABLE IF EXISTS ventas; 
DROP TABLE IF EXISTS productos; 
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS canal;

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



-- Consulta 1 

SELECT 
    v.fecha_venta AS fecha,
    c.nombre AS nombre_cliente,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;

--Consulta 2

SELECT 
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

--Consulta 3

SELECT 
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

--Consulta 4

-- 1. Agregamos la columna física a la tabla ventas
CREATE TABLE canal (
id_canal INT PRIMARY KEY,
nombre_canal VARCHAR (50),
);

INSERT INTO canal VALUES (1, 'OnLine');
INSERT INTO canal VALUES (2, 'Presencial');

SELECT * FROM canal;

--2. 

-- =========================================================================
-- Al crear la tabla nueva de "canal" tuve que reiniciar la de ventas para que se vean los cambios
-- =========================================================================

-- Borre las tablas previas 
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS canal;

-- 1. Cree la tabla CATEGORIAS
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);

-- 2. Cree la tabla CLIENTES
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL
);

-- 3. Cree la tabla PRODUCTOS
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT REFERENCES categorias (id_categoria),
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo BIT DEFAULT 1
);

-- 4. Cree la tabla CANAL
CREATE TABLE canal (
    id_canal INT PRIMARY KEY,
    nombre_canal VARCHAR(50) NOT NULL
);

-- 5. Cree la tabla VENTAS (donde ya inclui el canal que estaba mas arriba pero la consultano salia porque no agregue a los "INSERT DATA" de  ventas los canales que habia creado)
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT REFERENCES clientes (id_cliente),
    id_producto INT REFERENCES productos (id_producto),
    id_canal INT REFERENCES canal (id_canal),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL
);

-- =========================================================================
-- CARGA DE DATOS MAESTROS
-- =========================================================================

INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

INSERT INTO clientes VALUES (1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05');
INSERT INTO clientes VALUES (2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10');
INSERT INTO clientes VALUES (3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01');
INSERT INTO clientes VALUES (4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15');
INSERT INTO clientes VALUES (5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');

INSERT INTO productos VALUES (1, 'Laptop Pro 15',       1, 1200.00, 15, 1);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico',   2,   28.00, 80, 1);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"',      1,  450.00, 12, 1);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro',  3,  120.00, 35, 1);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB',     4,  130.00, 18, 1);
INSERT INTO productos VALUES (6, 'Teclado Mecánico',    2,   95.00, 40, 1);

INSERT INTO canal VALUES (1, 'OnLine');
INSERT INTO canal VALUES (2, 'Presencial');

-- =========================================================================
-- CARGA DE VENTAS (Con canales 1 y 2 distribuidos)
-- =========================================================================

INSERT INTO ventas VALUES (1,  1, 1, 1, 2, 1200.00, '2024-03-05'); -- Canal 1 (Online)
INSERT INTO ventas VALUES (2,  2, 2, 2, 5,   28.00, '2024-03-06'); -- Canal 2 (Presencial)
INSERT INTO ventas VALUES (3,  3, 3, 1, 1,  450.00, '2024-03-07');
INSERT INTO ventas VALUES (4,  1, 4, 2, 2,  120.00, '2024-03-08');
INSERT INTO ventas VALUES (5,  4, 5, 1, 3,  130.00, '2024-03-10');
INSERT INTO ventas VALUES (6,  2, 6, 2, 4,   95.00, '2024-03-11');
INSERT INTO ventas VALUES (7,  5, 1, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8,  3, 2, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas VALUES (9,  4, 4, 1, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2, 2,  450.00, '2024-03-15');

-- =========================================================================
-- CONSULTA 4: CONSOLIDADO POR CANAL (UNION ALL + GROUP BY)
-- =========================================================================

SELECT 
    canal,
    COUNT(id_venta) AS cantidad_transacciones,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM (
    SELECT id_venta, cantidad, precio_unitario, 'OnLine' AS canal
    FROM ventas
    WHERE id_canal = 1

    UNION ALL

    SELECT id_venta, cantidad, precio_unitario, 'Presencial' AS canal
    FROM ventas
    WHERE id_canal = 2
) AS consolidado_canales
GROUP BY canal;














