--Cambiarse a base postgres
\c postgres;

-- Create a new database called 'blog'
CREATE DATABASE blog;

--Conexión base blog
\c blog;

--Crear Tablas
CREATE TABLE usuarios(
  id SERIAL NOT NULL,
  email VARCHAR(50) not NULL,
  PRIMARY KEY(id)
);

CREATE TABLE posts(
  id SERIAL NOT NULL,
  usuario_id SMALLINT NOT NULL,
  titulo VARCHAR(50) NOT NULL,
  fecha DATE NOT NULL,
  PRIMARY key(id),
  FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE comentarios(
  id SERIAL NOT NULL,
  usuario_id SMALLINT NOT NULL,
  post_id SMALLINT NOT NULL,
  texto VARCHAR(240) NOT NULL,
  fecha DATE NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (post_id) REFERENCES posts(id),
  FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
);

--Importar datos
\copy usuarios FROM 'C:\\Users\\rafae\\OneDrive - usach.cl\\Cursos\\Desarrollador FullStack Javascript\\3 -Lenguaje De Consultas A Una Base De Datos PostgreSQL\\2 - Relaciones Y Operaciones Transaccionales\\Desafio_Creando_Blog\\assets\\csv\\usuarios.csv' CSV HEADER;

\copy posts FROM 'C:\\Users\\rafae\\OneDrive - usach.cl\\Cursos\\Desarrollador FullStack Javascript\\3 -Lenguaje De Consultas A Una Base De Datos PostgreSQL\\2 - Relaciones Y Operaciones Transaccionales\\Desafio_Creando_Blog\\assets\\csv\\posts.csv' CSV HEADER;

\copy comentarios FROM 'C:\\Users\\rafae\\OneDrive - usach.cl\\Cursos\\Desarrollador FullStack Javascript\\3 -Lenguaje De Consultas A Una Base De Datos PostgreSQL\\2 - Relaciones Y Operaciones Transaccionales\\Desafio_Creando_Blog\\assets\\csv\\comentarios.csv' CSV HEADER;

--Seleccionar el correo, id, y título de todos los post publicados por el usuario 5
SELECT u.email, p.id, p.titulo FROM (
  SELECT id, titulo, usuario_id FROM posts WHERE usuario_id=5
) AS p INNER JOIN usuarios AS u ON p.usuario_id=u.id;

--Listar el correo, id y el detalle de los comoentyarios que no hayan sido realizados por el usuario con el email usuario06@hotmail.com

SELECT s.email, c.id, c.texto FROM (
  SELECT id, email FROM usuarios WHERE email<>'usuario06@hotmail.com'
  ) AS s INNER JOIN comentarios AS c ON s.id=c.usuario_id ORDER BY c.id ASC;

--Listar usuarios que no han publicado posts
SELECT usuarios.* FROM usuarios LEFT JOIN posts on usuarios.id=posts.usuario_id WHERE posts.usuario_id is NULL;

--Listar todos los post con sus comentarios incluyendo aqullos que no poseen coemntarios
SELECT * FROM posts FULL OUTER JOIN comentarios on posts.id=comentarios.post_id ORDER BY posts.id
; 

--Listar todos los usuarios que hayan publicado un post en junio
SELECT s.fecha, c.id, c.email FROM (
  SELECT fecha, usuario_id FROM posts WHERE SELECT EXTRACT(MONTH FROM TIMESTAMP fecha) = 6
  ) AS s INNER JOIN usuarios AS c ON s.usuario_id=c.id ORDER BY c.id ASC;