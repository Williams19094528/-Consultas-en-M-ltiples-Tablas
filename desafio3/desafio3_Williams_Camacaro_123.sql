-- Crear base de datos
CREATE DATABASE desafio3_Williams_Camacaro_123;

-- Usar la base de datos creada
USE desafio3_Williams_Camacaro_123;

-- Crear tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL
);

-- Insertar 5 usuarios
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES
('admin@example.com', 'Admin', 'User', 'administrador'),
('user1@example.com', 'User1', 'LastName1', 'usuario'),
('user2@example.com', 'User2', 'LastName2', 'usuario'),
('user3@example.com', 'User3', 'LastName3', 'usuario'),
('user4@example.com', 'User4', 'LastName4', 'usuario');

-- Crear tabla de posts
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_actualizacion TIMESTAMP NOT NULL,
    destacado BOOLEAN NOT NULL,
    usuario_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Insertar 5 posts
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Post 1', 'Contenido del post 1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE, 1),
('Post 2', 'Contenido del post 2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 1),
('Post 3', 'Contenido del post 3', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE, 2),
('Post 4', 'Contenido del post 4', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 3),
('Post 5', 'Contenido del post 5', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE, NULL);

-- Crear tabla de comentarios
CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    usuario_id BIGINT,
    post_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- Insertar 5 comentarios
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Comentario 1', CURRENT_TIMESTAMP, 1, 1),
('Comentario 2', CURRENT_TIMESTAMP, 2, 1),
('Comentario 3', CURRENT_TIMESTAMP, 3, 1),
('Comentario 4', CURRENT_TIMESTAMP, 1, 2),
('Comentario 5', CURRENT_TIMESTAMP, 2, 2);

-- 2. Cruce de datos de usuarios y posts
SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuarios AS u
JOIN posts AS p ON u.id = p.usuario_id;

-- 3. Posts de administradores
SELECT p.id, p.titulo, p.contenido
FROM posts AS p
JOIN usuarios AS u ON p.usuario_id = u.id
WHERE u.rol = 'administrador';

-- 4. Contar posts de cada usuario
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios AS u
LEFT JOIN posts AS p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- 5. Email del usuario que ha creado más posts
SELECT u.email
FROM usuarios AS u
JOIN posts AS p ON u.id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;

-- 6. Fecha del último post de cada usuario
SELECT u.id, u.email, MAX(p.fecha_creacion) AS ultima_fecha_post
FROM usuarios AS u
JOIN posts AS p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- 7. Post con más comentarios
SELECT p.titulo, p.contenido
FROM posts AS p
JOIN comentarios AS c ON p.id = c.post_id
GROUP BY p.id
ORDER BY COUNT(c.id) DESC
LIMIT 1;

-- 8. Título, contenido de posts y comentarios, y email del usuario que los escribió
SELECT p.titulo, p.contenido AS contenido_post, c.contenido AS contenido_comentario, u.email
FROM posts AS p
JOIN comentarios AS c ON p.id = c.post_id
JOIN usuarios AS u ON c.usuario_id = u.id;

-- 9. Último comentario de cada usuario
SELECT u.id, u.email, c.contenido
FROM usuarios AS u
JOIN comentarios AS c ON u.id = c.usuario_id
WHERE c.fecha_creacion = (SELECT MAX(fecha_creacion) FROM comentarios WHERE usuario_id = u.id);

-- 10. Emails de usuarios que no han escrito ningún comentario
SELECT u.email
FROM usuarios AS u
LEFT JOIN comentarios AS c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;
