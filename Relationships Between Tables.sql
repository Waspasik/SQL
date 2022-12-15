/* Перепишите запрос на создание таблицы book , чтобы ее структура соответствовала структуре,
показанной на логической схеме (таблица genre уже создана, порядок следования столбцов - как
на логической схеме в таблице book, genre_id  - внешний ключ) . Для genre_id ограничение о
недопустимости пустых значений не задавать. В качестве главной таблицы для описания поля 
genre_idиспользовать таблицу genre следующей структуры:

Поле	Тип, описание
genre_id	INT PRIMARY KEY AUTO_INCREMENT
name_genre	VARCHAR(30) */

CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id),
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id)
);



/* Создать таблицу book той же структуры, что и на предыдущем шаге. Будем считать, что при
удалении автора из таблицы author, должны удаляться все записи о книгах из таблицы book,
написанные этим автором. А при удалении жанра из таблицы genre для соответствующей записи
book установить значение Null в столбце genre_id.  */

CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) ON DELETE SET NULL
);