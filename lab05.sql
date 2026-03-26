-- База даних: financial_database_biletskyi
-- Білецький Денис Ярославович, група 491
-- Лабораторна робота 5 - Тригери та процедури PostgreSQL

DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    account_number VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    account_type VARCHAR(20) CHECK (account_type IN ('checking', 'savings', 'credit'))
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    account_id INTEGER REFERENCES accounts(id),
    amount DECIMAL(10,2) NOT NULL,
    type VARCHAR(10) CHECK (type IN ('debit', 'credit')),
    description VARCHAR(200),
    transaction_date DATE DEFAULT CURRENT_DATE,
    category_id INTEGER
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

ALTER TABLE transactions ADD COLUMN IF NOT EXISTS category_id INTEGER REFERENCES categories(id);

INSERT INTO users (name, email, registration_date, is_active) VALUES
('Андрій Данилюк','andriy.danyliuk@email.com','2024-01-20',TRUE),
('Ганна Островська','hanna.ost@email.com','2024-02-28',TRUE),
('Валентин Панчук','valentin.panchuk@email.com','2024-03-20',TRUE),
('Крістіна Соломаха','krystyna.sol@email.com','2024-04-15',TRUE),
('Макар Коваленко','makar.kovalenko@email.com','2024-05-25',TRUE),
('Емілія Бондар','emilia.bondar@email.com','2024-06-30',TRUE),
('Ілля Вознюк','ilia.vozniuk@email.com','2024-08-05',TRUE),
('Яна Козловська','yana.kozlov@email.com','2024-09-18',TRUE),
('Марк Ткачук','mark.tkachuk@email.com','2024-10-10',FALSE),
('Денис Білецький','denys.biletskyi@email.com','2024-10-01',TRUE);

INSERT INTO accounts (user_id, account_number, balance, account_type) VALUES
(1,'ACC001',1550.25,'checking'),(1,'ACC002',4650.00,'savings'),(1,'ACC003',2375.00,'credit'),
(2,'ACC004',775.50,'checking'),(2,'ACC005',1225.00,'savings'),
(3,'ACC006',3275.75,'checking'),(3,'ACC007',2575.50,'credit'),
(4,'ACC008',875.00,'savings'),
(5,'ACC009',2000.00,'credit'),(5,'ACC010',4250.00,'savings'),(5,'ACC011',575.00,'checking'),
(6,'ACC012',1275.50,'savings'),(6,'ACC013',850.00,'checking'),
(7,'ACC014',2875.00,'credit'),(7,'ACC015',625.00,'savings'),(7,'ACC016',1475.00,'checking'),
(8,'ACC017',2775.50,'credit'),(8,'ACC018',925.00,'savings'),
(9,'ACC019',5075.00,'checking'),
(10,'ACC020',5775.00,'savings'),(10,'ACC021',750.00,'checking'),
(1,'ACC022',1775.00,'savings'),(2,'ACC023',3075.25,'credit'),
(3,'ACC024',1025.00,'checking'),(4,'ACC025',5425.00,'savings'),
(5,'ACC026',300.00,'credit'),(6,'ACC027',1975.00,'checking'),
(7,'ACC028',3325.00,'savings'),(8,'ACC029',1125.00,'credit'),
(9,'ACC030',5975.25,'checking');

INSERT INTO categories (name) VALUES
('Покупки'),('Зарплата'),('Оплата рахунків'),('Транспорт'),('Розваги'),
('Їжа'),('Іпотека'),('Бонус'),('Інвестиція'),('Повернення');

INSERT INTO transactions (account_id, amount, type, description, transaction_date) VALUES
(1,95.00,'debit','Хліб та молоко','2024-11-01'),(1,500.00,'credit','Зарплата','2024-11-05'),
(2,200.00,'debit','Wi-Fi та мобільний','2024-11-08'),
(3,150.00,'debit','Таксі до університету','2024-11-12'),
(5,255.00,'debit','Steam ігри','2024-11-17'),(5,310.00,'credit','Відсотки на залишок','2024-11-22'),
(9,405.00,'debit','Оренда кімнати','2024-11-10'),(9,565.00,'credit','Мотиваційний бонус','2024-11-14'),
(9,72.00,'debit','Обід в університеті','2024-11-15'),(9,140.00,'credit','Cashback на карту','2024-11-19'),
(9,190.00,'debit','Зошити та ручки','2024-11-25'),
(10,68.00,'debit','Еспресо','2024-11-02'),(10,355.00,'credit','Web3 проект','2024-11-11'),
(10,100.00,'debit','Udemy курс','2024-11-17'),
(11,120.00,'debit','Чохол для ноутбука','2024-11-15'),
(14,85.00,'debit','Куртка','2024-11-01'),(14,290.00,'credit','Гроші за товар','2024-11-06'),
(15,108.00,'debit','Тренажерний зал','2024-11-06'),(15,335.00,'credit','Завдання на фрілансі','2024-11-11'),
(15,65.00,'debit','Stand-up comedy','2024-11-16'),
(17,135.00,'debit','Зимова риболовля','2024-11-02'),(17,440.00,'credit','Токенсейл участь','2024-11-07'),
(17,92.00,'debit','Подкасти','2024-11-09'),(17,320.00,'credit','Резерв продаж','2024-11-14'),
(20,138.00,'debit','Більярд','2024-11-19'),(20,470.00,'credit','Депозитні відсотки','2024-11-24'),
(22,102.00,'debit','Автобус','2024-11-03'),(22,330.00,'credit','Репетиторство','2024-11-08'),
(22,160.00,'debit','Бургер з друзями','2024-11-11'),
(25,82.00,'debit','Сирники','2024-11-20'),(25,270.00,'credit','Страхування виплата','2024-11-25'),
(27,122.00,'debit','Кросівки для залу','2024-11-04'),(27,435.00,'credit','Аванс','2024-11-09'),
(27,138.00,'debit','Масаж','2024-11-10'),
(29,162.00,'debit','Лазертаг','2024-11-21'),(29,570.00,'credit','Play-to-earn game','2024-11-26'),
(30,182.00,'debit','Похід в гори','2024-11-05'),(30,595.00,'credit','Продаж вживаних речей','2024-11-10'),
(30,200.00,'debit','Цирк','2024-11-12'),
(1,220.00,'debit','Електричка','2024-11-22'),
(2,240.00,'debit','Овочі та фрукти','2024-11-06'),
(3,260.00,'debit','Онлайн тренінг','2024-11-13'),
(5,280.00,'debit','Макіато','2024-11-23'),
(7,300.00,'debit','Парфуми','2024-11-07'),
(10,320.00,'debit','Гантелі','2024-11-15'),
(14,340.00,'debit','Кіно з друзями','2024-11-24'),
(15,360.00,'debit','Велосипед','2024-11-09'),
(17,380.00,'debit','Квитки на виставку','2024-11-17'),
(20,400.00,'debit','Пінг-понг','2024-11-25'),
(22,420.00,'credit','Бабусин переказ','2024-11-27');

UPDATE transactions SET category_id = CASE
    WHEN description ILIKE '%зарплат%' OR description ILIKE '%аванс%' THEN (SELECT id FROM categories WHERE name='Зарплата')
    WHEN description ILIKE '%іпотек%' OR description ILIKE '%оренд%' OR description ILIKE '%кімнат%' THEN (SELECT id FROM categories WHERE name='Іпотека')
    WHEN description ILIKE '%бонус%' OR description ILIKE '%мотивац%' OR description ILIKE '%cashback%' OR description ILIKE '%страхуванн%' THEN (SELECT id FROM categories WHERE name='Бонус')
    WHEN description ILIKE '%інвест%' OR description ILIKE '%токен%' OR description ILIKE '%web3%' OR description ILIKE '%play-to-earn%' THEN (SELECT id FROM categories WHERE name='Інвестиція')
    WHEN description ILIKE '%повернен%' OR description ILIKE '%товар%' THEN (SELECT id FROM categories WHERE name='Повернення')
    WHEN description ILIKE '%їж%' OR description ILIKE '%обід%' OR description ILIKE '%еспресо%' OR description ILIKE '%бургер%' OR description ILIKE '%сирник%' OR description ILIKE '%овочі%' OR description ILIKE '%макіато%' THEN (SELECT id FROM categories WHERE name='Їжа')
    WHEN description ILIKE '%транспорт%' OR description ILIKE '%таксі%' OR description ILIKE '%автобус%' OR description ILIKE '%електричк%' THEN (SELECT id FROM categories WHERE name='Транспорт')
    WHEN description ILIKE '%wi-fi%' OR description ILIKE '%мобільн%' THEN (SELECT id FROM categories WHERE name='Оплата рахунків')
    WHEN description ILIKE '%покуп%' OR description ILIKE '%чохол%' OR description ILIKE '%куртка%' THEN (SELECT id FROM categories WHERE name='Покупки')
    ELSE (SELECT id FROM categories WHERE name='Розваги')
END;

-- Базові SELECT
SELECT * FROM transactions WHERE account_id = 1;
SELECT * FROM transactions WHERE account_id = 9 ORDER BY transaction_date DESC;
SELECT * FROM transactions WHERE account_id = 20 AND type = 'credit';

-- Сортування
SELECT * FROM transactions ORDER BY transaction_date DESC;
SELECT * FROM transactions ORDER BY amount DESC, transaction_date;

-- INNER JOIN
SELECT u.name, a.account_number, SUM(t.amount) AS total_amount
FROM users u
JOIN accounts a ON u.id = a.user_id
JOIN transactions t ON a.id = t.account_id
GROUP BY u.name, a.account_number;

-- LEFT JOIN
SELECT u.name, a.account_number
FROM users u
LEFT JOIN accounts a ON u.id = a.user_id
LEFT JOIN transactions t ON a.id = t.account_id
WHERE t.id IS NULL;

-- CROSS JOIN
SELECT u.name, t.description, t.amount
FROM users u
CROSS JOIN transactions t
LIMIT 9;

-- FULL OUTER JOIN
SELECT a.account_number, t.id AS transaction_id, t.amount
FROM accounts a
FULL OUTER JOIN transactions t ON a.id = t.account_id;

-- Агрегатні функції
SELECT account_type, SUM(balance) AS sum_balance FROM accounts GROUP BY account_type;
SELECT account_type, AVG(balance) AS avg_balance FROM accounts GROUP BY account_type;
SELECT type, COUNT(*) AS txn_count, SUM(amount) AS sum_amount FROM transactions GROUP BY type;

-- Оновлення
UPDATE accounts SET balance = balance + 950 WHERE account_type = 'savings';
SELECT account_number, balance FROM accounts WHERE account_type = 'savings';

UPDATE accounts a SET balance = a.balance + 45
FROM users u
WHERE a.user_id = u.id AND u.is_active = TRUE;
SELECT a.account_number, a.balance
FROM accounts a JOIN users u ON a.user_id = u.id
WHERE u.is_active = TRUE;

-- Видалення
DELETE FROM transactions WHERE transaction_date < CURRENT_DATE - INTERVAL '60 days';
SELECT * FROM transactions WHERE transaction_date < CURRENT_DATE - INTERVAL '60 days';

DELETE FROM transactions USING accounts
WHERE transactions.account_id = accounts.id AND accounts.balance < 0;
SELECT a.account_number, a.balance FROM accounts a WHERE a.balance < 0;

-- Підзапити
SELECT a.account_number, SUM(t.amount) AS total_amount
FROM accounts a JOIN transactions t ON a.id = t.account_id
GROUP BY a.account_number
ORDER BY total_amount DESC
LIMIT 6;

SELECT u.name, SUM(t.amount) AS total_amount
FROM users u
JOIN accounts a ON u.id = a.user_id
JOIN transactions t ON a.id = t.account_id
GROUP BY u.name
HAVING SUM(t.amount) > 190;

SELECT t.id, a.account_number, t.amount, t.type, c.name AS category, t.description, t.transaction_date
FROM transactions t
JOIN accounts a ON t.account_id = a.id
LEFT JOIN categories c ON t.category_id = c.id
ORDER BY t.id;

SELECT c.id, c.name
FROM categories c
WHERE (SELECT COALESCE(SUM(t.amount),0) FROM transactions t WHERE t.category_id = c.id) > 95;

-- Stored Procedure
CREATE OR REPLACE PROCEDURE calculate_balance_proc(p_account_id INT, OUT balance DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    SELECT COALESCE(SUM(CASE WHEN type='credit' THEN amount ELSE -amount END),0)
    INTO balance
    FROM transactions t
    WHERE t.account_id = p_account_id;
END;
$$;

CALL calculate_balance_proc(1, NULL);

-- Trigger
CREATE OR REPLACE FUNCTION update_balance() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE accounts
        SET balance = balance + (CASE WHEN NEW.type='credit' THEN NEW.amount ELSE -NEW.amount END)
        WHERE id = NEW.account_id;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE accounts
        SET balance = balance
            - (CASE WHEN OLD.type='credit' THEN OLD.amount ELSE -OLD.amount END)
            + (CASE WHEN NEW.type='credit' THEN NEW.amount ELSE -NEW.amount END)
        WHERE id = NEW.account_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE accounts
        SET balance = balance - (CASE WHEN OLD.type='credit' THEN OLD.amount ELSE -OLD.amount END)
        WHERE id = OLD.account_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS balance_trigger ON transactions;
CREATE TRIGGER balance_trigger
AFTER INSERT OR UPDATE OR DELETE ON transactions
FOR EACH ROW EXECUTE FUNCTION update_balance();

-- Тест trigger
SELECT balance FROM accounts WHERE id = 1;
INSERT INTO transactions (account_id, amount, type, description) VALUES (1, 200.00, 'credit', 'Перевірка роботи trigger');
SELECT balance FROM accounts WHERE id = 1;

-- Звіт
SELECT u.name, a.account_number, a.balance, a.account_type
FROM users u JOIN accounts a ON u.id = a.user_id
WHERE u.name = 'Денис Білецький';

SELECT u.name, SUM(a.balance) as total
FROM users u JOIN accounts a ON u.id = a.user_id
GROUP BY u.name ORDER BY total DESC;
