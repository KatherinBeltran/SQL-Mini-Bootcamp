-- ENTREGA SEMANA 1 — CATÁLOGO STREAMFLIX
-- Nombre: Katherin Beltran
-- Fecha: [02/06/2026]

-- PARTE 1: DISEÑO DE BASE DE DATOS

DROP DATABASE IF EXISTS streamflix;

CREATE DATABASE streamflix;

USE streamflix;

CREATE TABLE peliculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    titulo_original VARCHAR(200),
    director VARCHAR(100) NOT NULL,
    año INT NOT NULL,
    duracion_minutos INT,
    genero VARCHAR(50) NOT NULL,
    calificacion DECIMAL(3,1),
    sinopsis TEXT,
    idioma_original VARCHAR(50) DEFAULT 'Inglés',
    destacada BOOLEAN DEFAULT FALSE,
    fecha_agregada DATE DEFAULT (CURRENT_DATE)
);

-- PARTE 2: INSERCIÓN DE DATOS

INSERT INTO peliculas
(titulo, titulo_original, director, año, duracion_minutos, genero,
calificacion, sinopsis, idioma_original, destacada)
VALUES

('El Padrino', 'The Godfather', 'Francis Ford Coppola', 1972, 175,
'Drama', 9.2,
'La historia de la familia Corleone en el mundo de la mafia italiana.',
'Inglés', TRUE),

('Pulp Fiction', 'Pulp Fiction', 'Quentin Tarantino', 1994, 154,
'Crimen', 8.9,
'Historias entrelazadas de criminales en Los Ángeles.',
'Inglés', TRUE),

('El Caballero de la Noche', 'The Dark Knight',
'Christopher Nolan', 2008, 152,
'Acción', 9.0,
'Batman enfrenta al caótico Joker en Gotham City.',
'Inglés', TRUE),

('Inception', 'Inception', 'Christopher Nolan', 2010, 148,
'Ciencia Ficción', 8.8,
'Un ladrón que roba secretos del subconsciente durante el sueño.',
'Inglés', TRUE),

('Forrest Gump', 'Forrest Gump', 'Robert Zemeckis', 1994, 142,
'Drama', 8.8,
'La vida extraordinaria de un hombre simple que presencia eventos históricos.',
'Inglés', TRUE),

('Matrix', 'The Matrix', 'Lana y Lilly Wachowski', 1999, 136,
'Ciencia Ficción', 8.7,
'Un programador descubre que la realidad es una simulación.',
'Inglés', FALSE),

('El Señor de los Anillos: La Comunidad del Anillo',
'The Lord of the Rings: The Fellowship of the Ring',
'Peter Jackson', 2001, 178,
'Fantasía', 8.8,
'Frodo inicia su viaje para destruir el Anillo Único.',
'Inglés', TRUE),

('Gladiador', 'Gladiator', 'Ridley Scott', 2000, 155,
'Acción', 8.5,
'Un general romano busca venganza contra el emperador corrupto.',
'Inglés', FALSE),

('El Laberinto del Fauno', 'El Laberinto del Fauno',
'Guillermo del Toro', 2006, 118,
'Fantasía', 8.2,
'Una niña descubre un mundo mágico durante la Guerra Civil Española.',
'Español', FALSE),

('Interestelar', 'Interstellar', 'Christopher Nolan', 2014, 169,
'Ciencia Ficción', 8.6,
'Exploradores viajan por un agujero de gusano buscando un nuevo hogar.',
'Inglés', FALSE),

('Parásitos', 'Gisaengchung', 'Bong Joon-ho', 2019, 132,
'Thriller', 8.6,
'Una familia pobre infiltra la casa de una familia rica.',
'Coreano', TRUE),

('Tiempos Violentos', 'Reservoir Dogs', 'Quentin Tarantino', 1992, 99,
'Crimen', 8.3,
'Un atraco sale mal y los criminales sospechan de un traidor.',
'Inglés', FALSE),

('El Club de la Pelea', 'Fight Club', 'David Fincher', 1999, 139,
'Drama', 8.8,
'Un hombre insomne forma un club clandestino de pelea.',
'Inglés', FALSE),

('La Lista de Schindler', 'Schindler''s List',
'Steven Spielberg', 1993, 195,
'Drama', 9.0,
'La historia real de un empresario que salvó a más de mil judíos.',
'Inglés', TRUE),

('Toy Story', 'Toy Story', 'John Lasseter', 1995, 81,
'Animación', 8.3,
'Los juguetes de Andy cobran vida cuando él no está.',
'Inglés', FALSE);

-- PARTE 3: CONSULTAS

-- Q1
SELECT titulo, director, año
FROM peliculas;

-- Q2
SELECT titulo, calificacion, destacada
FROM peliculas
WHERE destacada = TRUE;

-- Q3
SELECT titulo, genero, año
FROM peliculas
WHERE genero = 'Ciencia Ficción';

-- Q4
SELECT titulo, calificacion
FROM peliculas
WHERE calificacion > 8.5
ORDER BY calificacion DESC;

-- Q5
SELECT titulo, año
FROM peliculas
WHERE año BETWEEN 1990 AND 2000
ORDER BY año;

-- Q6
SELECT titulo, genero
FROM peliculas
WHERE genero IN ('Drama', 'Thriller');

-- Q7
SELECT titulo
FROM peliculas
WHERE titulo LIKE 'El%';

-- Q8
SELECT DISTINCT director
FROM peliculas
WHERE director LIKE '%Nolan%';

-- Q9
SELECT titulo, calificacion
FROM peliculas
ORDER BY calificacion DESC
LIMIT 5;

-- Q10
SELECT titulo, año
FROM peliculas
ORDER BY año ASC
LIMIT 3;

-- Q11
SELECT titulo, duracion_minutos
FROM peliculas
WHERE duracion_minutos IS NOT NULL
ORDER BY duracion_minutos DESC;

-- BONUS

-- Reto 1
SELECT titulo, genero, calificacion, año
FROM peliculas
WHERE genero IN ('Acción', 'Ciencia Ficción')
AND calificacion > 8.0
AND año > 2000
ORDER BY calificacion DESC;

-- Reto 2
SELECT DISTINCT genero
FROM peliculas
ORDER BY genero;

-- Reto 3
SELECT titulo, duracion_minutos, calificacion
FROM peliculas
WHERE destacada = TRUE
AND duracion_minutos > 140
AND calificacion > 8.5
ORDER BY calificacion DESC;

-- DECISIONES DE DISEÑO

-- 1. ¿Por qué DECIMAL(3,1) para calificacion en vez de FLOAT?
-- Porque DECIMAL almacena valores exactos y evita errores
-- de redondeo. Es más adecuado para calificaciones.

-- 2. ¿Por qué VARCHAR(200) para titulo en vez de TEXT?
-- Porque los títulos suelen ser cortos y VARCHAR es más
-- eficiente para búsquedas e indexación.

-- 3. ¿Qué ventaja tiene AUTO_INCREMENT en id?
-- Genera identificadores únicos automáticamente y evita
-- duplicados o errores manuales.

-- 4. Si tuvieras que agregar precio_renta, ¿qué tipo usarías?
-- DECIMAL(5,2) porque representa dinero con precisión.

-- 5. ¿Qué fue lo que más te sorprendió esta semana?
-- Aprender cómo una base de datos puede modelar información
-- real y responder preguntas de negocio mediante consultas SQL.