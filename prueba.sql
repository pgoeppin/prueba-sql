CREATE DATABASE "prueba-Pablo-Goeppinger-311";
\c prueba-Pablo-Goeppinger-311

-- \i C:/Users/pgoep/Desktop/prueba-sql/prueba.sql

\qecho PREGUNTA 1
\qecho CREAR EL MODELO
\qecho .........


CREATE TABLE IF NOT EXISTS movies(id INT PRIMARY KEY, name VARCHAR(255), year INT);
CREATE TABLE IF NOT EXISTS tags(id INT PRIMARY KEY, tag VARCHAR(32));

CREATE TABLE IF NOT EXISTS movie_tag(
    movie_id INT,
    tag_id INT,
    FOREIGN KEY (movie_id)
    REFERENCES movies(id),
    FOREIGN KEY (tag_id)
    REFERENCES tags(id));


\qecho REVISAMOS LAS TABLAS
\qecho .........


\d movies
\d tags
\d movie_tag

\qecho PREGUNTA 2
\qecho INSERTAR DATOS
\qecho .........

INSERT INTO movies(id, name, year)
VALUES (1, 'The Shining', 1980);
INSERT INTO movies(id, name, year)
VALUES (2, 'Matrix', 1999);
INSERT INTO movies(id, name, year)
VALUES (3, 'The Truman Show', 1998);
INSERT INTO movies(id, name, year)
VALUES (4, 'Forest Gump', 1994);
INSERT INTO movies(id, name, year)
VALUES (5, 'The Silence of the Lambs', 1991);

SELECT * FROM movies;

INSERT INTO tags(id, tag)
VALUES (1, 'Drama');
INSERT INTO tags(id, tag)
VALUES (2, 'Terror');
INSERT INTO tags(id, tag)
VALUES (3, 'Suspense');
INSERT INTO tags(id, tag)
VALUES (4, 'Action');
INSERT INTO tags(id, tag)
VALUES (5, 'Comedy');

SELECT * FROM tags;

INSERT INTO movie_tag(movie_id, tag_id)
VALUES (1, 1);
INSERT INTO movie_tag(movie_id, tag_id)
VALUES (1, 2);
INSERT INTO movie_tag(movie_id, tag_id)
VALUES (1, 3);
INSERT INTO movie_tag(movie_id, tag_id)
VALUES (2, 4);
INSERT INTO movie_tag(movie_id, tag_id)
VALUES (2, 3);

SELECT * FROM movie_tag;
\qecho .........
\qecho PREGUNTA 3
\qecho CUENTA LA CANTIDAD DE TAGS QUE TIENE CADA PELICULA
SELECT movies.id, movies.name, movies.year, COUNT(movie_tag.tag_id) AS  "Cantidad de tags" FROM movies
LEFT JOIN movie_tag ON movies.id = movie_tag.movie_id
GROUP BY movies.id, movies.name, movies.year
ORDER BY movies.id;
\qecho .........
\qecho PREGUNTA 4
\qecho CREAR LAS TABLAS
\qecho .........

CREATE TABLE IF NOT EXISTS questions(id INT PRIMARY KEY, question VARCHAR(255), correct_answer VARCHAR);
CREATE TABLE IF NOT EXISTS users(id INT PRIMARY KEY, name VARCHAR(255), age INT);
CREATE TABLE IF NOT EXISTS answers(id INT PRIMARY KEY, answer VARCHAR(255), user_id INT, question_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id));

\d questions
\d users
\d answers

\qecho PREGUNTA 5
\qecho AGREGAR DATOS
\qecho .........


INSERT INTO questions(id, question, correct_answer)
VALUES (1, 'Quien es el jugador mas joven en anotar un gol en un mundial de futbol?', 'Pele');
INSERT INTO questions(id, question, correct_answer)
VALUES (2, 'Cual es el pais que ha ganado la mayor cantidad de mundiales de futbol?', 'Brasil');
INSERT INTO questions(id, question, correct_answer)
VALUES (3, 'Quien es el jugador con mayor cantidad de goles en todos los mundiales que ha jugado?', 'Miroslav Klose');
INSERT INTO questions(id, question, correct_answer)
VALUES (4, 'Que seleccion gano el ultimo mundial?', 'Francia');
INSERT INTO questions(id, question, correct_answer)
VALUES (5, 'Quien es el mayor goleador de la seleccion chilena?', 'Alexis Sanchez');

SELECT * FROM questions;

INSERT INTO users(id, name, age)
VALUES (1, 'Pedro Sanchez', 27);
INSERT INTO users(id, name, age)
VALUES (2, 'Juan Astudillo', 25);
INSERT INTO users(id, name, age)
VALUES (3, 'Felipe Henriquez', 34);
INSERT INTO users(id, name, age)
VALUES (4, 'Diego Silva', 35);
INSERT INTO users(id, name, age)
VALUES (5, 'Sergio Gonzalez', 29);

SELECT * FROM users;

INSERT INTO answers(id, answer, user_id, question_id)
VALUES (1, 'Pele', 1, 1);
INSERT INTO answers(id, answer, user_id, question_id)
VALUES (2, 'Pele', 3, 1);
INSERT INTO answers(id, answer, user_id, question_id)
VALUES (3, 'Brasil', 1, 2);
INSERT INTO answers(id, answer, user_id, question_id)
VALUES (4, 'Alemania', 2, 2);
INSERT INTO answers(id, answer, user_id, question_id)
VALUES (5, 'Francia', 3, 2);

SELECT * FROM answers;

\qecho PREGUNTA 6
\qecho CUENTA LA CANTIDAD DE RESPUESTAS CORRECTAS POR USUARIO
\qecho .........

SELECT users.id, users.name, COUNT(questions.correct_answer) AS "Respuestas correctas" FROM users
LEFT JOIN answers ON  users.id = answers.user_id
LEFT JOIN questions ON answers.question_id = questions.id
AND answers.answer = questions.correct_answer
GROUP BY users.id, users.name 
ORDER BY users.id;

\qecho PREGUNTA 7
\qecho POR CADA PREGUNTA CONTAR CUANTOS USUARIOS TUVIERON LA RESPUESTA CORRECTA
\qecho .........

SELECT questions.id, questions.question, COUNT(answers.answer) AS "Usuarios con respuesta correcta" FROM questions
LEFT JOIN answers ON questions.id = answers.question_id
AND questions.correct_answer = answers.answer
GROUP BY questions.id, questions.question
ORDER BY questions.id;

\qecho PREGUNTA 8
\qecho IMPLEMENTAR BORRADO CASCADA DE LAS RESPUESTAS AL BORRAR UN USUARIO Y BORRAR AL PRIMER USUARIO
\qecho .........
\qecho Tablas antes de la modificacion
\qecho .........
SELECT * FROM users;
SELECT * FROM answers;

\qecho Para implementar borrado cascada hay que dropear la restriccion y volver a crearla con el borrado cascada
\qecho .........

ALTER TABLE answers
DROP CONSTRAINT answers_user_id_fkey,
ADD CONSTRAINT answers_user_id_fkey
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE; 
\qecho Borramos el primer usuario
\qecho .........
DELETE FROM users WHERE id = 1;

\qecho Revisamos las tablas
\qecho .........

SELECT * FROM users;
SELECT * FROM answers;
\qecho .........
\qecho PREGUNTA 9
\qecho CREAR RESTRICCION USUARIOS MAYORES DE 18
\qecho ..........
ALTER TABLE users
ADD CONSTRAINT user_min_age CHECK (age >= 18);
INSERT INTO users
VALUES (6, 'Julio Hernandez', 15);

\qecho ..........
\qecho PREGUNTA 10
\qecho CREAR NUEVO CAMPO EMAIL CON RESTRICCION UNICO
\qecho ..........
ALTER TABLE users
ADD COLUMN email VARCHAR UNIQUE;

\d users

SELECT * FROM users;

\c postgres

DROP DATABASE "prueba-Pablo-Goeppinger-311";