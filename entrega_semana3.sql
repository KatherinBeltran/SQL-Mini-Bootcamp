-- ENTREGA WEEK 3 — BIBLIOTECA BIBLIOTECH
-- Nombre: Katherin Beltran
-- Fecha: [17/06/2026]

-- PARTE 1: ERD (https://dbdiagram.io/d/ERD-6a32b1c69340ecc065bbca49)

-- PARTE 2: DDL — Creación de tablas

DROP DATABASE IF EXISTS biblioteca;
CREATE DATABASE biblioteca;
USE biblioteca;

-- 2.1 categorias

CREATE TABLE categorias (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    nombre  VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT
);

-- 2.2 autores

CREATE TABLE autores (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(150) NOT NULL,
    pais             VARCHAR(50),
    fecha_nacimiento DATE,
    biografia        TEXT
);

CREATE TABLE libros (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    isbn             VARCHAR(20) UNIQUE NOT NULL,
    titulo           VARCHAR(250) NOT NULL,
    categoria_id     INT,
    año_publicacion  INT,
    precio           DECIMAL(10,2) NOT NULL,
    stock            INT DEFAULT 0,
    activo           BOOLEAN DEFAULT TRUE,
    fecha_agregado   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_libros_categoria
        FOREIGN KEY (categoria_id) REFERENCES categorias(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_anio   CHECK (año_publicacion BETWEEN 1450 AND 2100),
    CONSTRAINT chk_precio CHECK (precio > 0),
    CONSTRAINT chk_stock  CHECK (stock >= 0)
);

CREATE TABLE libros_autores (
    libro_id INT NOT NULL,
    autor_id INT NOT NULL,
    orden    INT DEFAULT 1,

    PRIMARY KEY (libro_id, autor_id),

    CONSTRAINT fk_la_libro
        FOREIGN KEY (libro_id) REFERENCES libros(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_la_autor
        FOREIGN KEY (autor_id) REFERENCES autores(id)
        ON DELETE CASCADE
);

-- 2.5 usuarios

CREATE TABLE usuarios (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    email           VARCHAR(150) UNIQUE NOT NULL,
    nombre          VARCHAR(150) NOT NULL,
    telefono        VARCHAR(20),
    tipo_membresia  ENUM('básica', 'premium', 'vip') DEFAULT 'básica',
    activo          BOOLEAN DEFAULT TRUE,
    fecha_registro  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE prestamos (
    id                        INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id                INT NOT NULL,
    libro_id                  INT NOT NULL,
    fecha_prestamo            DATE NOT NULL DEFAULT (CURRENT_DATE),
    fecha_devolucion_esperada DATE NOT NULL,
    fecha_devolucion_real     DATE,
    multa                     DECIMAL(10,2) DEFAULT 0.00,
    notas                     TEXT,

    CONSTRAINT fk_prestamos_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_prestamos_libro
        FOREIGN KEY (libro_id) REFERENCES libros(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_multa CHECK (multa >= 0),
    CONSTRAINT chk_fecha_devolucion CHECK (
        fecha_devolucion_real IS NULL OR
        fecha_devolucion_real >= fecha_prestamo
    )
);

-- PARTE 3: DML — Carga de datos

-- 3.1 categorias

INSERT INTO categorias (nombre, descripcion) VALUES
    ('Ficción',    'Novelas y cuentos de ficción'),
    ('Ciencia',    'Libros científicos y técnicos'),
    ('Historia',   'Libros de historia y biografías'),
    ('Infantil',   'Literatura para niños'),
    ('Tecnología', 'Programación, desarrollo, IA');

-- 3.2 autores

INSERT INTO autores (nombre, pais, fecha_nacimiento) VALUES
    ('Gabriel García Márquez', 'Colombia',       '1927-03-06'), 
    ('Isabel Allende',         'Chile',          '1942-08-02'), 
    ('Stephen Hawking',        'Reino Unido',    '1942-01-08'),  
    ('J.K. Rowling',           'Reino Unido',    '1965-07-31'),  
    ('Yuval Noah Harari',      'Israel',         '1976-02-24'),  
    ('Roald Dahl',             'Reino Unido',    '1916-09-13'),  
    ('Andrew S. Tanenbaum',    'Estados Unidos', '1944-03-16'),  
    ('Ian Goodfellow',         'Estados Unidos', '1985-01-01'),  
    ('Yoshua Bengio',          'Canadá',         '1964-03-05'), 
    ('Eric Matthes',           'Estados Unidos', '1970-01-01'),  
    ('Joshua Bloch',           'Estados Unidos', '1961-08-28');   

-- 3.3 libros

INSERT INTO libros (isbn, titulo, categoria_id, año_publicacion, precio, stock) VALUES
    ('978-0307474728', 'Cien años de soledad',                1, 1967, 18.99, 5),
    ('978-0142437247', 'La casa de los espíritus',            1, 1982, 16.50, 3),
    ('978-0439708180', 'Harry Potter y la Piedra Filosofal',  1, 1997, 22.99, 8),

    ('978-0553380163', 'Breve historia del tiempo',           2, 1988, 15.99, 4),
    ('978-0062316097', 'Sapiens: De animales a dioses',       2, 2011, 24.99, 6),
    ('978-0062464310', 'Homo Deus',                           2, 2015, 26.50, 4),

    ('978-0062315007', '21 lecciones para el siglo XXI',      3, 2018, 20.99, 5),
 
    ('978-0142410318', 'Matilda',                             4, 1988, 12.99, 10),
    ('978-0142410387', 'Charlie y la fábrica de chocolate',   4, 1964, 14.50, 7),
    ('978-0141365534', 'El gigante bonachón',                 4, 1982, 13.99, 6),

    ('978-0132126953', 'Sistemas Operativos Modernos',        5, 2007, 89.99, 3),
    ('978-0262035613', 'Deep Learning',                       5, 2016, 75.00, 2),
    ('978-0135957059', 'Redes de Computadoras',               5, 2010, 95.50, 2),
    ('978-1593279288', 'Python Crash Course',                 5, 2019, 39.99, 8),
    ('978-0134685991', 'Effective Java',                      5, 2017, 54.99, 4);

-- 3.4 libros_autores  (junction N:M — primero libros y autores)

INSERT INTO libros_autores (libro_id, autor_id, orden) VALUES
    (1,  1, 1),   
    (2,  2, 1),   
    (3,  4, 1),   
    (4,  3, 1),   
    (5,  5, 1),   
    (6,  5, 1),   
    (7,  5, 1),   
    (8,  6, 1),   
    (9,  6, 1),  
    (10, 6, 1),   
    (11, 7, 1),  
    (12, 8, 1),   
    (12, 9, 2),  
    (13, 7, 1),   
    (14,10, 1),   
    (15,11, 1);  

-- 3.5 usuarios

INSERT INTO usuarios (email, nombre, telefono, tipo_membresia) VALUES
    ('ana.garcia@email.com',      'Ana García',      '555-0001', 'premium'),  
    ('carlos.lopez@email.com',    'Carlos López',    '555-0002', 'básica'),    
    ('maria.torres@email.com',    'María Torres',    '555-0003', 'vip'),       
    ('juan.perez@email.com',      'Juan Pérez',       NULL,      'básica'),    
    ('lucia.martinez@email.com',  'Lucía Martínez',  '555-0005', 'premium'),   
    ('sofia.rodriguez@email.com', 'Sofía Rodríguez', '555-0006', 'básica'),    
    ('diego.fernandez@email.com', 'Diego Fernández',  NULL,      'básica');    

INSERT INTO prestamos
    (usuario_id, libro_id, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, multa)
VALUES
    (1, 1, '2024-01-01', '2024-01-15', '2024-01-14',  0.00),   
    (2, 3, '2024-01-05', '2024-01-19', '2024-01-25', 15.00),  
    (3, 5, '2024-01-08', '2024-01-22', '2024-01-20',  0.00), 
    (1, 8, '2024-01-10', '2024-01-24', '2024-01-23',  0.00),   
    (4, 9, '2024-01-12', '2024-01-26', '2024-02-05', 25.00),  

    (1,  4, DATE_SUB(CURDATE(), INTERVAL 20 DAY), DATE_SUB(CURDATE(), INTERVAL  6 DAY), NULL, 0.00),  
    (5,  5, DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_ADD(CURDATE(), INTERVAL  2 DAY), NULL, 0.00),  
    (6, 10, DATE_SUB(CURDATE(), INTERVAL  9 DAY), DATE_ADD(CURDATE(), INTERVAL  5 DAY), NULL, 0.00), 
    (7, 14, DATE_SUB(CURDATE(), INTERVAL  6 DAY), DATE_ADD(CURDATE(), INTERVAL  8 DAY), NULL, 0.00), 
    (2, 11, DATE_SUB(CURDATE(), INTERVAL  4 DAY), DATE_ADD(CURDATE(), INTERVAL 10 DAY), NULL, 0.00);  

SELECT
    (SELECT COUNT(*) FROM categorias)    AS categorias,
    (SELECT COUNT(*) FROM autores)       AS autores,
    (SELECT COUNT(*) FROM libros)        AS libros,
    (SELECT COUNT(*) FROM libros_autores)AS asociaciones,
    (SELECT COUNT(*) FROM usuarios)      AS usuarios,
    (SELECT COUNT(*) FROM prestamos)     AS prestamos;

-- PARTE 4: Reportes (Fase 5)

-- 4.1 Libros de Tecnología con su autor

SELECT
    l.titulo,
    a.nombre AS autor,
    l.precio,
    l.stock
FROM libros l
JOIN categorias     c  ON l.categoria_id = c.id
JOIN libros_autores la ON l.id = la.libro_id
JOIN autores        a  ON la.autor_id = a.id
WHERE c.nombre = 'Tecnología'
ORDER BY l.titulo, la.orden;

-- 4.2 Usuarios con préstamos activos y días de retraso

SELECT
    u.nombre AS usuario,
    l.titulo AS libro,
    p.fecha_devolucion_esperada,
    DATEDIFF(CURDATE(), p.fecha_devolucion_esperada) AS dias_retraso
FROM usuarios u
JOIN prestamos p ON u.id = p.usuario_id
JOIN libros    l ON p.libro_id = l.id
WHERE p.fecha_devolucion_real IS NULL
ORDER BY p.fecha_devolucion_esperada;

-- 4.3 Top 5 libros más prestados

SELECT
    l.titulo,
    a.nombre AS autor,
    COUNT(p.id) AS veces_prestado
FROM libros l
LEFT JOIN prestamos      p  ON l.id = p.libro_id
LEFT JOIN libros_autores la ON l.id = la.libro_id AND la.orden = 1
LEFT JOIN autores        a  ON la.autor_id = a.id
GROUP BY l.id, l.titulo, a.nombre
ORDER BY veces_prestado DESC, l.titulo
LIMIT 5;

-- 4.4 Total de multas por usuario (solo quienes deben algo)

SELECT
    u.nombre AS usuario,
    COUNT(p.id) AS num_prestamos,
    SUM(p.multa) AS total_multas
FROM usuarios u
LEFT JOIN prestamos p ON u.id = p.usuario_id
GROUP BY u.id, u.nombre
HAVING total_multas > 0
ORDER BY total_multas DESC;

-- PARTE 5: Transacciones de préstamo y devolución (Fase 6)

-- 5.1 Registrar préstamo: María (id=3) toma Deep Learning (id=12)

START TRANSACTION;

-- 1. ¿Hay stock? Si devuelve 0 filas → ROLLBACK y avisar
SELECT id, titulo, stock FROM libros WHERE id = 12 AND stock > 0;

-- 2. Reducir stock
UPDATE libros SET stock = stock - 1 WHERE id = 12;

-- 3. Registrar el préstamo (devolución esperada en 14 días)
INSERT INTO prestamos
    (usuario_id, libro_id, fecha_prestamo, fecha_devolucion_esperada)
VALUES
    (3, 12, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));

-- 4. Verificar las dos mitades
SELECT id, titulo, stock FROM libros WHERE id = 12;
SELECT * FROM prestamos WHERE id = LAST_INSERT_ID();

COMMIT;

-- 5.2 Procesar devolución: Ana devuelve libro 4 (préstamo id=6)

START TRANSACTION;

-- 1. Calcular días de retraso y multa
SET @dias_retraso = (
    SELECT DATEDIFF(CURDATE(), fecha_devolucion_esperada)
    FROM prestamos WHERE id = 6
);
SET @multa = GREATEST(0, @dias_retraso * 2.50);

-- 2. Marcar como devuelto y aplicar multa
UPDATE prestamos
SET fecha_devolucion_real = CURDATE(),
    multa = @multa
WHERE id = 6;

-- 3. Devolver la copia al inventario
UPDATE libros
SET stock = stock + 1
WHERE id = (SELECT libro_id FROM prestamos WHERE id = 6);

-- 4. Verificar
SELECT id, fecha_devolucion_real, multa FROM prestamos WHERE id = 6;

COMMIT;

-- PARTE 6: Pruebas de integridad referencial (Fase 7)

-- 6.1 ON DELETE SET NULL — eliminar la categoría "Historia"

START TRANSACTION;

SELECT id, titulo, categoria_id FROM libros WHERE id = 7;

DELETE FROM categorias WHERE id = 3;

SELECT id, titulo, categoria_id FROM libros WHERE id = 7;

ROLLBACK;  

-- 6.2 ON DELETE RESTRICT — intentar eliminar Ana (id=1) con préstamos activos

DELETE FROM usuarios WHERE id = 1;

START TRANSACTION;

SET SQL_SAFE_UPDATES = 0;           
DELETE FROM prestamos WHERE usuario_id = 1;
SET SQL_SAFE_UPDATES = 1;           

DELETE FROM usuarios WHERE id = 1;  

ROLLBACK;

SELECT nombre FROM usuarios WHERE id = 1;   

-- 6.3 CHECK — rechazar valores inválidos

-- Año fuera del rango permitido (1450–2100)
INSERT INTO libros (isbn, titulo, año_publicacion, precio)
VALUES ('978-0000000001', 'Manuscrito medieval', 1200, 29.99);

-- Precio negativo
INSERT INTO libros (isbn, titulo, año_publicacion, precio)
VALUES ('978-0000000002', 'Libro gratis', 2020, -10.00);

-- Confirmar que siguen siendo exactamente 15 libros (ninguno entró)
SELECT COUNT(*) AS total_libros FROM libros;   

-- BONUS OPCIONAL: tabla resenias

CREATE TABLE resenias (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id    INT NOT NULL,
    libro_id      INT NOT NULL,
    calificacion  INT,
    comentario    TEXT,
    fecha         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_calificacion CHECK (calificacion BETWEEN 1 AND 5),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (libro_id)   REFERENCES libros(id)   ON DELETE CASCADE,
    UNIQUE (usuario_id, libro_id)  
);

INSERT INTO resenias (usuario_id, libro_id, calificacion, comentario) VALUES
    (1,  1, 5, 'Una obra maestra absoluta. García Márquez en su máximo esplendor.'),
    (2,  3, 5, 'Leí todos los libros de la saga. Rowling creó un mundo increíble.'),
    (3,  5, 4, 'Perspectiva fascinante de la historia humana. Muy recomendado.'),
    (5, 14, 5, 'El mejor libro para aprender Python desde cero. Muy práctico.'),
    (1,  8, 4, 'Hawking explica conceptos complejos de forma sorprendentemente clara.');

-- BONUS OPCIONAL: trigger de auditoría de precios

CREATE TABLE auditoria_precios (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    libro_id        INT,
    precio_anterior DECIMAL(10,2),
    precio_nuevo    DECIMAL(10,2),
    fecha           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER tr_auditoria_precio
AFTER UPDATE ON libros
FOR EACH ROW
BEGIN
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO auditoria_precios (libro_id, precio_anterior, precio_nuevo)
        VALUES (NEW.id, OLD.precio, NEW.precio);
    END IF;
END$$
DELIMITER ;

UPDATE libros SET precio = 69.99 WHERE id = 12;
SELECT * FROM auditoria_precios;
