DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS cart CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS roles CASCADE;

CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(150) NOT NULL,
    name VARCHAR(100),
    phone VARCHAR(30),
    default_address VARCHAR(255),
    role_id INTEGER NOT NULL DEFAULT 2 REFERENCES roles(id),
    discount_percent NUMERIC(5,2) DEFAULT 0
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL
);

CREATE TABLE services (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    area INTEGER NOT NULL,
    price NUMERIC(12,2) NOT NULL,
    image_url TEXT,
    category_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
    discount_percent NUMERIC(5,2) DEFAULT 0
);

CREATE TABLE cart (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    service_id INTEGER REFERENCES services(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    UNIQUE(user_id, service_id)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    address VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'В обработке',
    total NUMERIC(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    service_id INTEGER REFERENCES services(id),
    quantity INTEGER NOT NULL,
    price NUMERIC(12,2) NOT NULL
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    service_id INTEGER REFERENCES services(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO roles (id, title) VALUES
  (1, 'Администратор'),
  (2, 'Пользователь');
SELECT setval('roles_id_seq', 2);

INSERT INTO users (email, password, name, phone, default_address, role_id, discount_percent) VALUES
  ('admin@lunar.ru', 'admin123', 'Администратор', '+7 900 000-00-00', 'Лунная база "Артемида"', 1, 0),
  ('user@lunar.ru',  'user123',  'Иван Петров',    '+7 900 111-22-33', 'Лунная база "Селена"',   2, 10);

INSERT INTO categories (id, title) VALUES
  (1, 'Кратеры'),
  (2, 'Моря'),
  (3, 'Обратная сторона Луны'),
  (4, 'Лагранжевы точки'),
  (5, 'Лунные пещеры'),
  (6, 'Полюса'),
  (7, 'Горные хребты');
SELECT setval('categories_id_seq', 7);

INSERT INTO services (name, description, area, price, category_id, discount_percent, image_url) VALUES
  ('Кратер Тихо',
   'Живописный кратер с видом на лунные равнины. Идеален для обсерватории.',
   50, 25000000, 1, 0, '/images/Кратер Тихо.png'),

  ('Кратер Коперник',
   'Молодой кратер с яркими лучевыми выбросами. Отличное место для туристической базы.',
   75, 32000000, 1, 5, '/images/Кратер Коперник.jpg'),

  ('Кратер Аристарх',
   'Самый яркий объект на Луне, видимый с Земли невооружённым глазом.',
   60, 28000000, 1, 0, '/images/Кратер Аристарх.jpg'),

  ('Кратер Платон',
   'Тёмное лавовое дно идеально для строительства купола.',
   45, 22000000, 1, 10, '/images/Кратер Платон.jpg'),

  ('Кратер Кеплер',
   'Кратер с хорошо заметной системой лучей, популярен у астрономов.',
   55, 26000000, 1, 0, '/images/Кратер Кеплер.jpg'),

  ('Море Спокойствия',
   'Участок в сердце первой лунной базы. Развитая инфраструктура.',
   100, 45000000, 2, 10, '/images/Море Ясности.jpg'),

  ('Море Дождей',
   'Крупнейшее лунное море, богатое полезными ископаемыми.',
   120, 52000000, 2, 5, '/images/Море Дождей.jpg'),

  ('Море Ясности',
   'Ровная базальтовая поверхность, идеальна для взлётных площадок.',
   90, 42000000, 2, 0, '/images/Море Ясности.jpg'),

  ('Море Кризисов',
   'Лавовое плато с редкими минералами. Перспективно для добычи.',
   110, 48000000, 2, 15, '/images/Море Кризисов.jpg'),

  ('Океан Бурь',
   'Гигантская тёмная область — крупнейшее лунное море.',
   200, 80000000, 2, 20, '/images/Океан Бурь.jpg'),

  ('Бассейн Эйткен',
   'Крупнейший ударный бассейн на обратной стороне Луны.',
   150, 65000000, 3, 0, '/images/Бассейн Эйткен.jpg'),

  ('Кратер Джордано Бруно',
   'Молодой кратер на обратной стороне с уникальным рельефом.',
   40, 38000000, 3, 0, '/images/Кратер Джордано Бруно.jpg'),

  ('Кратер Циолковский',
   'Назван в честь основоположника космонавтики. Символическое место.',
   70, 55000000, 3, 10, '/images/Кратер Циолковский.jpg'),

  ('Кратер Ломоносов',
   'Кратер с интересной геологической структурой на обратной стороне.',
   55, 44000000, 3, 0, '/images/Кратер Ломоносов.jpg'),

  ('Точка L1',
   'Идеальное место для научной станции между Землёй и Луной.',
   30, 70000000, 4, 0, '/images/Лагранжевы точки.jpg'),

  ('Точка L2',
   'Идеальное место для научной станции на обратной стороне.',
   30, 72000000, 4, 0, '/images/Лагранжевы точки'),

  ('Точка L4',
   'Стабильная точка с минимальными затратами на удержание.',
   35, 68000000, 4, 5, '/images/Лагранжевы точки.jpg'),

  ('Точка L5',
   'Симметричная L4 — отличное место для орбитального города.',
   35, 68000000, 4, 5, '/images/Лагранжевы точки.jpg'),

  ('Лунная пещера Мариус',
   'Защищённая от радиации пещера для колонии. Температура стабильна.',
   60, 55000000, 5, 15, '/images/Лавовая трубка Апеннины.jpg'),

  ('Пещера в Море Спокойствия',
   'Обнаружена в 2024 году, глубина более 100 метров.',
   80, 62000000, 5, 10, '/images/Лавовая трубка Апеннины.jpg'),

  ('Лавовая трубка Апеннины',
   'Древняя лавовая трубка, идеальна для подземного города.',
   90, 70000000, 5, 0, '/images/Лавовая трубка Апеннины.jpg'),

  ('Южный полюс — пик Шеклтона',
   'Максимальное освещение, рядом залежи водяного льда.',
   40, 90000000, 6, 0, '/images/Южный полюс.jpg'),

  ('Северный полюс Луны',
   'Постоянно затенённые кратеры с водяным льдом.',
   50, 85000000, 6, 10, '/images/Южный полюс.jpg'),

  ('Кратер Кабеус',
   'Возле южного полюса, содержит залежи льда.',
   45, 78000000, 6, 0, '/images/Кратер Кабеус.jpg'),

  ('Хребет Апеннины',
   'Живописные горы высотой до 5 км. Идеальны для экстремального туризма.',
   70, 58000000, 7, 0, '/images/Хребет Апеннины.jpg'),

  ('Хребет Кавказ',
   'Горная система рядом с Морем Ясности.',
   65, 54000000, 7, 5, '/images/Хребет Апеннины.jpg'),

  ('Горы Гемские',
   'Горный массив с уникальными панорамными видами.',
   60, 50000000, 7, 0, '/images/Хребет Апеннины.jpg'),

  ('Пик Гюйгенса',
   'Высочайшая вершина Луны — 5.5 км над уровнем моря.',
   55, 75000000, 7, 0, '/images/Пик Гюйгенса.jpg');