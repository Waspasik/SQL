/* Исходная база данных ко всем заданиям представляет вид

Таблица book
+---------+-----------------------+-----------+----------+--------+--------+
| book_id | title                 | author_id | genre_id | price  | amount |
+---------+-----------------------+-----------+----------+--------+--------+
| 1       | Мастер и Маргарита    | 1         | 1        | 670.99 | 3      |
| 2       | Белая гвардия         | 1         | 1        | 540.50 | 5      |
| 3       | Идиот                 | 2         | 1        | 460.00 | 10     |
| 4       | Братья Карамазовы     | 2         | 1        | 799.01 | 3      |
| 5       | Игрок                 | 2         | 1        | 480.50 | 10     |
| 6       | Стихотворения и поэмы | 3         | 2        | 650.00 | 15     |
| 7       | Черный человек        | 3         | 2        | 570.20 | 6      |
| 8       | Лирика                | 4         | 2        | 518.99 | 2      |
+---------+-----------------------+-----------+----------+--------+--------+
Таблица supply
+-----------+-----------------------+------------------+--------+--------+
| supply_id | title                 | author           | price  | amount |
+-----------+-----------------------+------------------+--------+--------+
| 1         | Доктор Живаго         | Пастернак Б.Л.   | 380.80 | 4      |
| 2         | Черный человек        | Есенин С.А.      | 570.20 | 6      |
| 3         | Белая гвардия         | Булгаков М.А.    | 540.50 | 7      |
| 4         | Идиот                 | Достоевский Ф.М. | 360.80 | 3      |
| 5         | Стихотворения и поэмы | Лермонтов М.Ю.   | 255.90 | 4      |
| 6         | Остров сокровищ       | Стивенсон Р.Л.   | 599.99 | 5      |
+-----------+-----------------------+------------------+--------+--------+
Таблица author                          Таблица genre
+-----------+------------------+	+----------+-------------+			
| author_id | name_author      |	| genre_id | name_genre  |			
+-----------+------------------+	+----------+-------------+			
| 1         | Булгаков М.А.    |	| 1        | Роман       |			
| 2         | Достоевский Ф.М. |	| 2        | Поэзия      |			
| 3         | Есенин С.А.      |	| 3        | Приключения |			
| 4         | Пастернак Б.Л.   |	+----------+-------------+			
| 5         | Лермонтов М.Ю.   |							
+-----------+------------------+

*/



/* Для книг, которые уже есть на складе (в таблице book), но по другой цене, чем в поставке (supply),
необходимо в таблице book увеличить количество на значение, указанное в поставке,  и пересчитать цену.
А в таблице  supply обнулить количество этих книг. */

UPDATE book
    INNER JOIN author ON author.author_id = book.author_id
    INNER JOIN supply ON book.title = supply.title
                         and supply.author = author.name_author
SET book.amount = book.amount + supply.amount,
    book.price = (book.price * book.amount + supply.price * supply.amount) / (book.amount + supply.amount),
    supply.amount = 0
WHERE book.price <> supply.price;

SELECT * FROM book;

SELECT * FROM supply;



/* Включить новых авторов в таблицу author с помощью запроса на добавление, а затем вывести все данные
из таблицы author.  Новыми считаются авторы, которые есть в таблице supply, но нет в таблице author. */

INSERT INTO author (name_author)
SELECT supply.author
FROM 
    author 
    RIGHT JOIN supply on author.name_author = supply.author
WHERE name_author IS Null;

SELECT * FROM author;



/* Добавить новые книги из таблицы supply в таблицу book на основе сформированного выше запроса. Затем
вывести для просмотра таблицу book.  */

INSERT INTO book (title, author_id, price, amount)
SELECT title, author_id, price, amount
FROM author
    INNER JOIN supply ON author.name_author = supply.author
WHERE supply.amount <> 0;

SELECT * FROM book;



/*  Занести для книги «Стихотворения и поэмы» Лермонтова жанр «Поэзия», а для книги «Остров сокровищ»
Стивенсона - «Приключения». (Использовать два запроса).  */

UPDATE book
SET genre_id = 
      (
       SELECT genre_id 
       FROM genre 
       WHERE name_genre = 'Поэзия'
      )
WHERE title = 'Стихотворения и поэмы';

UPDATE book
SET genre_id = 
      (
       SELECT genre_id 
       FROM genre 
       WHERE name_genre = 'Приключения'
      )
WHERE title = 'Остров сокровищ';

SELECT * FROM book;