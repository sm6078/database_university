--Часть 1. Создание структуры. Определить самостоятельно типы данных для каждого поля(колонки). Самостоятельно определить что является primary key и foreign key.

CREATE DATABASE university;
CREATE SCHEMA IF NOT EXISTS schemaspec;


--1. Создать таблицу с факультетами: id, имя факультета, стоимость обучения
CREATE TABLE faculty (
     id int primary key,
	 name varchar(50),
	 cost numeric(8,2)
);

--2. Создать таблицу с курсами: id, номер курса, id факультета
CREATE TABLE course(
	id int primary key,
	course_number int,
	faculty_id int references faculty(id)
);	
--3. Создать таблицу с учениками: id, имя, фамилия, отчество, бюджетник/частник, id курса
CREATE TABLE student (
	id int primary key,
	first_name varchar(30),
	last_name varchar(30),
	patronymic varchar(30),
	budget boolean,
	course_id int references course(id)
);


--========
--Часть 2. Заполнение данными:
---1. Создать два факультета: Инженерный (30 000 за курс) , Экономический (49 000 за курс)
INSERT INTO faculty values (1, 'Инженерный', 30000);
INSERT INTO faculty values (2, 'Экономический', 49000);

---2. Создать 1 курс на Инженерном факультете: 1 курс
INSERT INTO course values(1, 1, 1);

---3. Создать 2 курса на экономическом факультете: 1, 4 курс
INSERT INTO course values(2, 1, 2);
INSERT INTO course values(3, 4, 2);

---4. Создать 5 учеников:
----Петров Петр Петрович, 1 курс инженерного факультета, бюджетник
----Иванов Иван Иваныч, 1 курс инженерного факультета, частник
----Михно Сергей Иваныч, 4 курс экономического факультета, бюджетник
----Стоцкая Ирина Юрьевна, 4 курс экономического факультета, частник
----Младич Настасья (без отчества), 1 курс экономического факультета, частник
INSERT INTO student values(1, 'Петров', 'Петр', 'Петрович', true, 1);
INSERT INTO student values(2, 'Иванов', 'Иван', 'Иваныч', false, 1);
INSERT INTO student values(3, 'Михно', 'Сергей', 'Иваныч', true, 3);
INSERT INTO student values(4, 'Стоцкая', 'Ирина', 'Юрьевна', false, 3);
INSERT INTO student(id, first_name, last_name, budget, course_id) 
values(5, 'Младич', 'Настасья', false, 2);

--Часть 3. Выборка данных. Необходимо написать запросы, которые выведут экран:
---1. Вывести всех студентов, кто платит больше 30_000.
SELECT *
	FROM student 
	where budget = false
	and course_id in (SELECT id FROM course 
	where faculty_id = (SELECT id
	FROM faculty where cost > 30000));
	
---2. Перевести всех студентов Петровых на 1 курс экономического факультета.
UPDATE student
	SET course_id = (SELECT id FROM course 
	WHERE course_number = 1
	AND 
	faculty_id = (SELECT id FROM faculty WHERE name LIKE 'Эконом%'))
	WHERE first_name LIKE 'Петров%';
	
---3. Вывести всех студентов без отчества или фамилии.
SELECT *
	FROM student 
	WHERE 
	patronymic IS NULL
	OR
	first_name IS NULL;

---4. Вывести всех студентов содержащих в фамилии или в имени или в отчестве "ван". (пример name like '%Петр%' - найдет всех Петров, ---Петровичей, Петровых)
SELECT *
	FROM student 
	WHERE
	first_name LIKE '%ван%' 
	OR
	last_name like '%ван%' 
	OR
	patronymic LIKE '%ван%' 
	;

---5. Удалить все записи из всех таблиц.
TRUNCATE TABLE faculty, course, student;