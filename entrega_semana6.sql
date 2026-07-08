-- ENTREGA WEEK 6 — GLOBALMART ANÁLISIS
-- Subconsultas y operadores avanzados
-- Nombre: Katherin Beltran
-- Fecha: [07/07/2026]

-- PARTE 1: SETUP

DROP DATABASE IF EXISTS globalmart;
CREATE DATABASE globalmart;
USE globalmart;

CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    categoria_id INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    pais VARCHAR(50),
    fecha_registro DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Datos abreviados (suficientes para que los reportes devuelvan resultados sensatos)
INSERT INTO categorias (nombre) VALUES
    ('Electrónica'), ('Ropa'), ('Deportes'), ('Hogar'), ('Libros');

INSERT INTO productos (nombre, categoria_id, precio, costo, stock) VALUES
    ('Laptop HP',           1,  799.99, 600.00, 25),
    ('Mouse Logitech',      1,   25.99,  15.00, 150),
    ('Teclado Mecánico',    1,   89.99,  50.00, 80),
    ('Audífonos Sony',      1,  149.99,  90.00, 45),
    ('Monitor LG',          1,  299.99, 200.00, 30),
    ('Camiseta Nike',       2,   29.99,  12.00, 200),
    ('Zapatillas Adidas',   2,   89.99,  45.00, 90),
    ('Pantalón Levi',       2,   59.99,  30.00, 120),
    ('Chaqueta NF',         2,  149.99,  80.00, 50),
    ('Balón Fútbol',        3,   24.99,  10.00, 100),
    ('Raqueta Tenis',       3,  119.99,  60.00, 35),
    ('Bicicleta',           3,  499.99, 300.00, 15),
    ('Pesas 20kg',          3,   79.99,  40.00, 45),
    ('Licuadora',           4,   59.99,  30.00, 70),
    ('Cafetera',            4,  199.99, 120.00, 40),
    ('Aspiradora',          4,  399.99, 250.00, 20),
    ('Clean Code',          5,   39.99,  20.00, 60),
    ('Design Patterns',     5,   49.99,  25.00, 45),
    ('Refactoring',         5,   42.99,  21.00, 55),
    ('Producto sin ventas', 4,   29.99,  10.00, 30);  -- nunca vendido

INSERT INTO clientes (nombre, email, pais, fecha_registro) VALUES
    ('Ana García',     'ana@email.com',     'España',    '2023-01-15'),
    ('Carlos López',   'carlos@email.com',  'México',    '2023-02-20'),
    ('María Torres',   'maria@email.com',   'Argentina', '2023-03-10'),
    ('Juan Pérez',     'juan@email.com',    'Colombia',  '2023-04-05'),
    ('Lucía Martínez', 'lucia@email.com',   'Chile',     '2023-05-12'),
    ('Diego Fernández','diego@email.com',   'Perú',      '2023-06-08'),
    ('Cliente nuevo',  'nuevo@email.com',   'México',    '2024-04-01');  -- sin compras

INSERT INTO ventas (cliente_id, producto_id, cantidad, precio_unitario, fecha_venta) VALUES
    -- Ana compra de las 5 categorías
    (1, 1,  1, 799.99, '2024-01-05'),  -- Electrónica
    (1, 6,  2,  29.99, '2024-01-10'),  -- Ropa
    (1, 10, 1,  24.99, '2024-01-15'),  -- Deportes
    (1, 14, 1,  59.99, '2024-01-20'),  -- Hogar
    (1, 17, 1,  39.99, '2024-01-25'),  -- Libros
    -- Carlos compra solo Electrónica y Ropa
    (2, 2,  3,  25.99, '2024-02-01'),
    (2, 3,  1,  89.99, '2024-02-05'),
    (2, 7,  2,  89.99, '2024-02-10'),
    -- María compra Electrónica y Deportes
    (3, 4,  1, 149.99, '2024-02-15'),
    (3, 11, 1, 119.99, '2024-02-20'),
    -- Juan compra Hogar
    (4, 15, 1, 199.99, '2024-03-01'),
    (4, 16, 1, 399.99, '2024-03-05'),
    -- Lucía compra Libros (mucho)
    (5, 17, 5,  39.99, '2024-03-10'),
    (5, 18, 3,  49.99, '2024-03-15'),
    -- Diego compra Electrónica y Ropa
    (6, 5,  1, 299.99, '2024-04-01'),
    (6, 9,  1, 149.99, '2024-04-05');

-- PARTE 2: SUBCONSULTAS ESCALARES

-- R1. Productos más caros que el promedio general
SELECT nombre, precio
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos)
ORDER BY precio DESC;

-- R2. Clientes que gastaron más que el promedio de gasto por cliente
SELECT
    cl.nombre,
    SUM(v.cantidad * v.precio_unitario) AS total_gastado
FROM clientes cl
JOIN ventas v ON cl.id = v.cliente_id
GROUP BY cl.id, cl.nombre
HAVING SUM(v.cantidad * v.precio_unitario) > (
    SELECT AVG(total_por_cliente)
    FROM (
        SELECT SUM(cantidad * precio_unitario) AS total_por_cliente
        FROM ventas
        GROUP BY cliente_id
    ) AS por_cliente
);

-- R3. Categorías con precio promedio mayor al promedio global
SELECT
    c.nombre,
    ROUND(AVG(p.precio), 2) AS precio_promedio_categoria
FROM categorias c
JOIN productos p ON c.id = p.categoria_id
GROUP BY c.id, c.nombre
HAVING AVG(p.precio) > (SELECT AVG(precio) FROM productos);

-- R4. Productos sin ventas (con NOT IN)
SELECT id, nombre, stock
FROM productos
WHERE id NOT IN (
    SELECT DISTINCT producto_id
    FROM ventas
    WHERE producto_id IS NOT NULL
);

-- R5. Productos con stock por encima del promedio de SU categoría (subconsulta correlacionada)
SELECT
    p.nombre,
    p.stock,
    c.nombre AS categoria
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
WHERE p.stock > (
    SELECT AVG(p2.stock)
    FROM productos p2
    WHERE p2.categoria_id = p.categoria_id
);

-- PARTE 3: OPERADORES AVANZADOS

-- R6. Clientes que han comprado al menos 1 producto de Electrónica (IN)
SELECT DISTINCT cl.nombre
FROM clientes cl
JOIN ventas v ON cl.id = v.cliente_id
WHERE v.producto_id IN (
    SELECT p.id
    FROM productos p
    JOIN categorias cat ON p.categoria_id = cat.id
    WHERE cat.nombre = 'Electrónica'
);

-- R7. Productos que tienen al menos 1 venta (EXISTS)
SELECT p.nombre, p.precio
FROM productos p
WHERE EXISTS (
    SELECT 1
    FROM ventas v
    WHERE v.producto_id = p.id
);

-- R8. Clientes sin ninguna compra (NOT EXISTS)
SELECT cl.nombre, cl.email, cl.pais
FROM clientes cl
WHERE NOT EXISTS (
    SELECT 1
    FROM ventas v
    WHERE v.cliente_id = cl.id
);

-- R9. Productos más caros que TODOS los de Ropa (> ALL)
SELECT nombre, precio
FROM productos
WHERE precio > ALL (
    SELECT p.precio
    FROM productos p
    JOIN categorias c ON p.categoria_id = c.id
    WHERE c.nombre = 'Ropa'
);

-- R10. Productos más caros que AL MENOS UNO de Deportes (> ANY)
SELECT nombre, precio
FROM productos
WHERE precio > ANY (
    SELECT p.precio
    FROM productos p
    JOIN categorias c ON p.categoria_id = c.id
    WHERE c.nombre = 'Deportes'
)
ORDER BY precio;

-- PARTE 4: UNION

-- R11. Etiquetar productos como "En stock" o "Agotado"
SELECT nombre, precio, 'En stock' AS estado
FROM productos
WHERE stock > 0

UNION ALL

SELECT nombre, precio, 'Agotado' AS estado
FROM productos
WHERE stock = 0

ORDER BY estado, nombre;

-- R12. Top 3 productos más caros por categoría (Electrónica, Ropa, Deportes)
(SELECT p.nombre, p.precio, 'Electrónica' AS categoria
 FROM productos p
 JOIN categorias c ON p.categoria_id = c.id
 WHERE c.nombre = 'Electrónica'
 ORDER BY p.precio DESC
 LIMIT 3)

UNION ALL

(SELECT p.nombre, p.precio, 'Ropa' AS categoria
 FROM productos p
 JOIN categorias c ON p.categoria_id = c.id
 WHERE c.nombre = 'Ropa'
 ORDER BY p.precio DESC
 LIMIT 3)

UNION ALL

(SELECT p.nombre, p.precio, 'Deportes' AS categoria
 FROM productos p
 JOIN categorias c ON p.categoria_id = c.id
 WHERE c.nombre = 'Deportes'
 ORDER BY p.precio DESC
 LIMIT 3);

-- PARTE 5: QUERIES COMPLEJAS

-- R13. Clientes que compraron en TODAS las categorías
SELECT cl.nombre
FROM clientes cl
WHERE (
    SELECT COUNT(DISTINCT p.categoria_id)
    FROM ventas v
    JOIN productos p ON v.producto_id = p.id
    WHERE v.cliente_id = cl.id
) = (SELECT COUNT(*) FROM categorias);

-- R14. Productos cuyas unidades vendidas superan el promedio de unidades vendidas por producto
SELECT
    p.nombre,
    SUM(v.cantidad) AS unidades_vendidas
FROM productos p
JOIN ventas v ON p.id = v.producto_id
GROUP BY p.id, p.nombre
HAVING SUM(v.cantidad) > (
    SELECT AVG(unidades_por_producto)
    FROM (
        SELECT SUM(cantidad) AS unidades_por_producto
        FROM ventas
        GROUP BY producto_id
    ) AS por_producto
)
ORDER BY unidades_vendidas DESC;

-- BONUS: 2 queries inventadas

-- B1. Clientes cuyo gasto total supera el gasto de TODOS los clientes de México (> ALL)
SELECT cl.nombre,
       (SELECT SUM(v.cantidad * v.precio_unitario)
        FROM ventas v
        WHERE v.cliente_id = cl.id) AS total_gastado
FROM clientes cl
WHERE (
    SELECT SUM(v.cantidad * v.precio_unitario)
    FROM ventas v
    WHERE v.cliente_id = cl.id
) > ALL (
    SELECT SUM(v2.cantidad * v2.precio_unitario)
    FROM ventas v2
    JOIN clientes cl2 ON v2.cliente_id = cl2.id
    WHERE cl2.pais = 'México'
    GROUP BY v2.cliente_id
);

-- B2. Categorías que no tienen ningún producto agotado (NOT EXISTS)
SELECT c.nombre
FROM categorias c
WHERE NOT EXISTS (
    SELECT 1
    FROM productos p
    WHERE p.categoria_id = c.id
      AND p.stock = 0
);