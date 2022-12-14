/* Исходная база данных ко всем заданиям представляет вид

+---------------+--------+------------------------------+----------+----------------+--------------+
| name          | number | violation                    | sum_fine | date_violation | date_payment |
|               | _plate |                              |          |                |              |
+---------------+--------+------------------------------+----------+----------------+--------------+
| Баранов П.Е.  | Р523ВТ | Превышение скорости(от 40... | 500.00   | 2020-01-12     | 2020-01-17   |
| Абрамова К.А. | О111АВ | Проезд на запрещающий сигнал | 1000.00  | 2020-01-14     | 2020-02-27   |
| Яковлев Г.Р.  | Т330ТТ | Превышение скорости(от 20... | 500.00   | 2020-01-23     | 2020-02-23   |
| Яковлев Г.Р.  | М701АА | Превышение скорости(от 20... | 250.00   | 2020-01-12     | 2020-01-22   |
| Колесов С.П.  | К892АХ | Превышение скорости(от 20... | 500.00   | 2020-02-01     | NULL         |
| Баранов П.Е.  | Р523ВТ | Превышение скорости(от 40... | 2000.00  | 2020-02-14     | 2020-03-05   |
| Абрамова К.А. | О111АВ | Проезд на запрещающий сигн...| 2000.00  | 2020-02-23     | NULL         |
| Яковлев Г.Р.  | Т330ТТ | Проезд на запрещающий сигн...| 500.00   | 2020-03-03     | 2020-03-22   |
+---------------+--------+------------------------------+----------+----------------+--------------+

*/



/* Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными
из таблицы traffic_violation. При этом суммы заносить только в пустые поля столбца  sum_fine.

Таблица traffic_violationсоздана и заполнена. */

UPDATE fine f, traffic_violation tv
SET f.sum_fine = tv.sum_fine
WHERE f.sum_fine IS NULL AND f.violation = tv.violation;



/* Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили
одно и то же правило   два и более раз. При этом учитывать все нарушения, независимо от того оплачены
они или нет. Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру
машины и, наконец, по нарушению. */

SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(violation) > 1
ORDER BY name, number_plate, violation;



/* В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге
записей.  */

UPDATE fine, (
     SELECT name, number_plate, violation
     FROM fine
     GROUP BY name, number_plate, violation
     HAVING COUNT(violation) > 1
     ORDER BY name, number_plate, violation
    ) AS query_in
SET fine.sum_fine = fine.sum_fine * 2
WHERE fine.name = query_in.name AND
    fine.violation = query_in.violation AND
    fine.number_plate = query_in.number_plate AND
    fine.date_payment IS NULL;



/* Водители оплачивают свои штрафы. В таблице payment занесены даты их оплаты.

Необходимо:

в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых
занесена в таблицу payment) , если оплата произведена не позднее 20 дней со дня нарушения. */

UPDATE fine f, payment p
SET f.sum_fine = IF(DATEDIFF(p.date_payment, p.date_violation) <= 20, f.sum_fine / 2, f.sum_fine),
    f.date_payment = p.date_payment
WHERE f.name = p.name AND
    f.violation = p.violation AND
    f.number_plate = p.number_plate AND
    f.date_payment IS NULL;


/* Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах (Фамилию и инициалы
водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine. */

CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL;



/* Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года.  */

DELETE FROM fine
WHERE date_violation < '2020.02.01';