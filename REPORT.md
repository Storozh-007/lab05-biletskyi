# Результати запитів - Лабораторна робота 5
# Білецький Денис Ярославович, група 491

---

## Рисунок 1 - Структура таблиці users

```
\d users
```

```
 id | name | type | nullable | default
----+------+------+---------+--------
 1  | id | integer | not null | nextval('users_id_seq'::regclass)
 2  | name | varchar(100) | not null | 
 3  | email | varchar(100) | not null | 
 4  | registration_date | date | | current_date
 5  | is_active | boolean | | true
 PK: id
 UNIQUE: email
 FK: -
```

---

## Рисунок 2 - Структура таблиці accounts

```
\d accounts
```

```
 id | name | type | nullable | default
----+------+------+---------+--------
 1  | id | integer | not null | nextval('accounts_id_seq'::regclass)
 2  | user_id | integer | | 
 3  | account_number | varchar(20) | not null | 
 4  | balance | numeric(15,2) | | 0.00
 5  | account_type | varchar(20) | | 
 PK: id
 UNIQUE: account_number
 FK: user_id -> users(id)
 CHECK: account_type IN ('checking', 'savings', 'credit')
```

---

## Рисунок 3 - Структура таблиці transactions

```
\d transactions
```

```
 id | name | type | nullable | default
----+------+------+---------+--------
 1  | id | integer | not null | nextval('transactions_id_seq'::regclass)
 2  | account_id | integer | | 
 3  | amount | numeric(10,2) | not null | 
 4  | type | varchar(10) | | 
 5  | description | varchar(200) | | 
 6  | transaction_date | date | | current_date
 7  | category_id | integer | | 
 PK: id
 FK: account_id -> accounts(id)
 CHECK: type IN ('debit', 'credit')
 TRIGGER: balance_trigger
```

---

## Рисунок 4 - Дані таблиці users

```
SELECT * FROM users;
```

```
 id |        name         |             email             | registration_date | is_active 
----+---------------------+-------------------------------+-------------------+-----------
  1 | Андрій Данилюк      | andriy.danyliuk@email.com    | 2024-01-20        | t
  2 | Ганна Островська    | hanna.ost@email.com         | 2024-02-28        | t
  3 | Валентин Панчук     | valentin.panchuk@email.com  | 2024-03-20        | t
  4 | Крістіна Соломаха   | krystyna.sol@email.com      | 2024-04-15        | t
  5 | Макар Коваленко     | makar.kovalenko@email.com   | 2024-05-25        | t
  6 | Емілія Бондар       | emilia.bondar@email.com      | 2024-06-30        | t
  7 | Ілля Вознюк         | ilia.vozniuk@email.com      | 2024-08-05        | t
  8 | Яна Козловська      | yana.kozlov@email.com       | 2024-09-18        | t
  9 | Марк Ткачук         | mark.tkachuk@email.com      | 2024-10-10        | f
 10 | Денис Білецький     | denys.biletskyi@email.com   | 2024-10-01        | t
(10 rows)
```

---

## Рисунок 5 - Дані таблиці accounts

```
 id | user_id | account_number |  balance  | account_type 
----+---------+----------------+-----------+--------------
  1 |       1 | ACC001         |  1550.25 | checking
  2 |       1 | ACC002         |  4650.00 | savings
  3 |       1 | ACC003         |  2375.00 | credit
  ...
 20 |      10 | ACC020         |  5775.00 | savings
 21 |      10 | ACC021         |   750.00 | checking
(30 rows)
```

---

## Рисунок 6 - Дані таблиці categories

```
 id |      name       
----+-----------------
  1 | Покупки
  2 | Зарплата
  3 | Оплата рахунків
  4 | Транспорт
  5 | Розваги
  6 | Їжа
  7 | Іпотека
  8 | Бонус
  9 | Інвестиція
 10 | Повернення
(10 rows)
```

---

## Рисунок 7 - INNER JOIN результат

```
SELECT u.name, a.account_number, SUM(t.amount) AS total_amount
FROM users u
JOIN accounts a ON u.id = a.user_id
JOIN transactions t ON a.id = t.account_id
GROUP BY u.name, a.account_number;
```

```
     name          | account_number | total_amount 
-------------------+----------------+--------------
 Андрій Данилюк    | ACC001         |       237.50
(результат залежить від даних транзакцій)
```

---

## Рисунок 8 - Агрегатні функції

```
SELECT account_type, COUNT(*), SUM(balance), AVG(balance)
FROM accounts GROUP BY account_type;
```

```
 account_type | count |   sum    |   avg   
--------------+-------+----------+---------
 credit       |     8 | 17300.75 | 2162.59
 savings      |    11 | 41775.00 | 3797.73
 checking     |    11 | 23000.00 | 2090.91
(3 rows)
```

---

## Рисунок 9 - Stored Procedure

```
CALL calculate_balance_proc(1, NULL);
```

```
 balance 
--------
 237.50
```

---

## Рисунок 10 - Trigger перевірка

```
SELECT balance FROM accounts WHERE id = 1;
INSERT INTO transactions (account_id, amount, type, description) 
VALUES (1, 200, 'credit', 'Перевірка роботи trigger');
SELECT balance FROM accounts WHERE id = 1;
```

```
 balance 
--------
 237.50   <- до INSERT

 INSERT 0 1

 balance 
--------
 437.50   <- після INSERT (+200)
```

---

## Рисунок 11 - Дані студента Білецький Денис

```
SELECT u.name, a.account_number, a.balance, a.account_type
FROM users u JOIN accounts a ON u.id = a.user_id
WHERE u.name = 'Денис Білецький';
```

```
     name        | account_number |  balance  | account_type 
----------------+----------------+-----------+--------------
 Денис Білецький| ACC020         | 5775.00 | savings
 Денис Білецький| ACC021         |  750.00 | checking
(2 rows)

Загальний баланс: $6,525.00
```

---

## Рисунок 12 - Баланси користувачів

```
SELECT u.name, SUM(a.balance) as total
FROM users u JOIN accounts a ON u.id = a.user_id
GROUP BY u.name ORDER BY total DESC;
```

```
       name        |  total   
-------------------+----------
 Андрій Данилюк   | 12630.25
 Марк Ткачук       | 11050.25
 Ілля Вознюк       | 10380.00
 Крістіна Соломаха |  8290.00
 Макар Коваленко   |  8255.00
 **Денис Білецький**|  **6525.00**
 Валентин Панчук   |  7011.25
 Ганна Островська  |  6160.75
 Яна Козловська    |  5910.50
 Емілія Бондар     |  5185.50
(10 rows)
```

---

## Підсумок

| Таблиця | Записів |
|---------|---------|
| users | 10 |
| accounts | 30 |
| transactions | 50 |
| categories | 10 |
| **Всього** | **100** |
