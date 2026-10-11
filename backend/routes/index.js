const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const { requireAdmin } = require('../middleware/auth');
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

const BAD_WORDS_BASE = [
    'бля', 'блят', 'блядь', 'бляди', 'блядск', 'блядство',
    'хуй', 'хуя', 'хую', 'хуе', 'хуё', 'хуи', 'хуйн', 'хуйня',
    'пизд', 'пизда', 'пиздец', 'пиздёж', 'пиздюк',
    'ебан', 'ебал', 'ебет', 'ебёт', 'еби', 'ебуч',
    'ебат', 'ебало', 'ебло', 'ёбан', 'ёб', 'ебн',
    'сука', 'суки', 'сучара', 'сучка', 'сучонок',
    'мудак', 'мудила', 'мудозвон', 'мудень',
    'гандон', 'гондон', 'гад',
    'уебан', 'уебищ', 'уёбищ', 'уёбок',
    'залуп', 'манда', 'мандав', 'мандавош',
    'долбоеб', 'долбоёб', 'долбаеб',
    'хер', 'херн', 'херня', 'херов',
    'жопа', 'жоп', 'жопошн',
    'пидор', 'пидар', 'пидр', 'педик',
    'шлюх', 'шлюш', 'шалав', 'шалав',
    'fuck', 'fuk', 'phuck', 'fck', 'fak',
    'shit', 'sh1t', 'shet',
    'bitch', 'b1tch', 'beatch',
    'asshole', 'ass', 'bastard', 'cunt', 'dick', 'whore', 'slut',
    'nigg', 'niger', 'n1gg',
    'blyat', 'blya', 'bl9t', 'bljad', 'bljаt', 'bluat',
    'pizda', 'pizdec', 'huy', 'hui', 'huylo', 'huilo',
    'suka', 'suke', 'suki', 'suc',
    'eban', 'ebat', 'ebal', 'eblan',
    'mudak', 'gandon', 'pidor', 'pidar',
    'zalupa', 'manda', 'dolboeb',
    'xa', 'xy', 'xyi', 'xuy', 'xyn',
];

const LEET_MAP = {
    '0': 'о', 'o': 'о',
    '1': 'и', 'i': 'и', 'l': 'л',
    '3': 'з', 'e': 'е', 'ё': 'е',
    '4': 'а', 'a': 'а',
    '5': 'с', 's': 'с',
    '6': 'б', 'b': 'б',
    '7': 'т', 't': 'т',
    '8': 'в',
    '9': 'д', 'g': 'д',
    '@': 'а',
    '$': 'с',
    '!': 'и',
    '|': 'и',
    'y': 'у', 'u': 'у',
    'x': 'х', 'h': 'х',
    'k': 'к', 'c': 'к',
    'p': 'р', 'r': 'р',
    'n': 'н',
    'm': 'м',
    'v': 'в', 'w': 'в',
    'z': 'з',
    'f': 'ф',
    'q': 'к',
};

function normalizeText(text) {
    let t = String(text || '').toLowerCase();
    t = t.replace(/[\s\.\,\-_*+@#\$%\^&\|\\\/\(\)\[\]\{\}<>:;'"`~!?]/g, '');
    t = t.split('').map(ch => LEET_MAP[ch] || ch).join('');
    t = t.replace(/(.)\1{2,}/g, '$1$1');
    return t;
}

function checkCensorship(text) {
    const normalized = normalizeText(text);
    for (const word of BAD_WORDS_BASE) {
        const pattern = word.split('').map(ch => ch.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')).join('+');
        const re = new RegExp(pattern);
        if (re.test(normalized)) {
            return word;
        }
    }
    return null;
}

const NAME_REGEX = /^[А-Яа-яЁёA-Za-z\s-]+$/;
const PHONE_REGEX = /^\+?[0-9\s\-\(\)]{10,20}$/;
const MAX_ORDERS_PER_DAY = 3;
const DEFAULT_CATEGORY_ID = 8;

function validateName(name) {
    if (!name || name.trim().length < 2) return 'Имя должно быть не короче 2 символов';
    if (!name.trim().includes(' ')) return 'Укажите имя и фамилию';
    if (!NAME_REGEX.test(name)) return 'ФИО должно содержать только буквы';
    return null;
}

router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        const result = await pool.query(
            `SELECT u.id, u.email, u.name, u.phone, u.default_address,
                    u.discount_percent, u.first_order_done,
                    COALESCE(r.title, 'Пользователь') AS role_title
             FROM users u
             LEFT JOIN roles r ON u.role_id = r.id
             WHERE u.email = $1 AND u.password = $2`,
            [email, password]
        );
        if (result.rows.length === 0) return res.status(401).json({ error: 'Неверный email или пароль' });
        res.json(result.rows[0]);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.post('/register', async (req, res) => {
    try {
        const { name, email, password, phone } = req.body;
        const nameErr = validateName(name);
        if (nameErr) return res.status(400).json({ error: nameErr });
        if (!PHONE_REGEX.test(phone)) return res.status(400).json({ error: 'Неверный формат телефона' });

        const roleRes = await pool.query(`SELECT id FROM roles WHERE title = 'Пользователь'`);
        const roleId = roleRes.rows[0]?.id || 2;
        const insert = await pool.query(
            `INSERT INTO users (name, email, password, phone, role_id)
             VALUES ($1, $2, $3, $4, $5) RETURNING id`,
            [name, email, password, phone, roleId]
        );
        const result = await pool.query(
            `SELECT u.id, u.email, u.name, u.phone, u.default_address,
                    u.discount_percent, u.first_order_done,
                    COALESCE(r.title, 'Пользователь') AS role_title
             FROM users u LEFT JOIN roles r ON u.role_id = r.id WHERE u.id = $1`,
            [insert.rows[0].id]
        );
        res.json(result.rows[0]);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.post('/forgot-password', async (req, res) => {
    try {
        const { email } = req.body;
        const userRes = await pool.query('SELECT id FROM users WHERE email = $1', [email]);
        if (userRes.rows.length === 0) return res.status(404).json({ error: 'Пользователь с таким email не найден' });

        const code = Math.floor(100000 + Math.random() * 900000).toString();
        const expires = new Date(Date.now() + 15 * 60 * 1000);
        await pool.query(
            'UPDATE users SET reset_code = $1, reset_code_expires = $2 WHERE email = $3',
            [code, expires, email]
        );

        await transporter.sendMail({
            from: process.env.EMAIL_USER,
            to: email,
            subject: 'Сброс пароля Lunar Estates',
            text: `Ваш код для сброса пароля: ${code}. Код действителен 15 минут.`
        });

        res.json({ success: true, message: 'Код отправлен на почту' });
    } catch (err) {
        console.error('Ошибка отправки:', err);
        res.status(500).json({ error: 'Не удалось отправить письмо. Проверьте настройки почты.' });
    }
});

router.post('/reset-password', async (req, res) => {
    try {
        const { email, code, newPassword } = req.body;
        const result = await pool.query(
            'SELECT id FROM users WHERE email = $1 AND reset_code = $2 AND reset_code_expires > NOW()',
            [email, code]
        );
        if (result.rows.length === 0) return res.status(400).json({ error: 'Неверный или просроченный код' });
        await pool.query(
            'UPDATE users SET password = $1, reset_code = NULL, reset_code_expires = NULL WHERE email = $2',
            [newPassword, email]
        );
        res.json({ success: true, message: 'Пароль изменен' });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.get('/services', async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT s.id, s.name, s.description, s.area, s.price, s.image_url,
                    s.discount_percent, s.stock, s.category_id, c.title AS category_title
             FROM services s LEFT JOIN categories c ON s.category_id = c.id ORDER BY s.id`
        );
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.post('/services', requireAdmin, async (req, res) => {
    try {
        const { name, description, area, price, category_id, discount_percent, image_url, stock } = req.body;
        if (Number(price) <= 0) return res.status(400).json({ error: 'Цена должна быть больше 0' });
        if (Number(stock) < 0) return res.status(400).json({ error: 'Количество не может быть отрицательным' });
        await pool.query(
            `INSERT INTO services (name, description, area, price, category_id, discount_percent, image_url, stock)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
            [name, description, area, price, category_id, discount_percent || 0, image_url, stock || 0]
        );
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/services/:id', requireAdmin, async (req, res) => {
    try {
        const { name, description, area, price, category_id, discount_percent, image_url, stock } = req.body;
        if (Number(price) <= 0) return res.status(400).json({ error: 'Цена должна быть больше 0' });
        await pool.query(
            `UPDATE services SET name=$1, description=$2, area=$3, price=$4,
                    category_id=$5, discount_percent=$6, image_url=$7, stock=$8 WHERE id=$9`,
            [name, description, area, price, category_id, discount_percent || 0, image_url, stock || 0, req.params.id]
        );
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.delete('/services/:id', requireAdmin, async (req, res) => {
    try {
        await pool.query('DELETE FROM services WHERE id = $1', [req.params.id]);
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.get('/categories', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM categories ORDER BY id');
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.post('/categories', requireAdmin, async (req, res) => {
    try {
        await pool.query('INSERT INTO categories (title) VALUES ($1)', [req.body.title]);
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/categories/:id', requireAdmin, async (req, res) => {
    try {
        await pool.query('UPDATE categories SET title = $1 WHERE id = $2', [req.body.title, req.params.id]);
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.delete('/categories/:id', requireAdmin, async (req, res) => {
    const client = await pool.connect();
    try {
        const id = Number(req.params.id);
        if (id === DEFAULT_CATEGORY_ID) {
            return res.status(400).json({ error: 'Нельзя удалить категорию "Без категории"' });
        }

        await client.query('BEGIN');

        await client.query(
            'UPDATE services SET category_id = $1 WHERE category_id = $2',
            [DEFAULT_CATEGORY_ID, id]
        );

        await client.query('DELETE FROM categories WHERE id = $1', [id]);

        await client.query('COMMIT');
        res.json({ success: true });
    } catch (err) {
        await client.query('ROLLBACK');
        res.status(500).json({ error: err.message });
    } finally {
        client.release();
    }
});

router.get('/cart/:userId', async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT c.id, c.quantity, s.id AS service_id, s.name, s.price, s.discount_percent,
                    s.image_url, s.stock, cat.title AS category_title
             FROM cart c JOIN services s ON c.service_id = s.id
             LEFT JOIN categories cat ON s.category_id = cat.id WHERE c.user_id = $1`,
            [req.params.userId]
        );
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.post('/cart', async (req, res) => {
    try {
        const { user_id, service_id, quantity } = req.body;
        if (quantity > 10) return res.status(400).json({ error: 'Максимум 10 штук одного товара' });

        const serviceRes = await pool.query('SELECT stock FROM services WHERE id = $1', [service_id]);
        if (serviceRes.rows.length === 0) return res.status(404).json({ error: 'Товар не найден' });
        const stock = serviceRes.rows[0].stock;

        const existingRes = await pool.query(
            'SELECT quantity FROM cart WHERE user_id = $1 AND service_id = $2',
            [user_id, service_id]
        );
        const currentInCart = existingRes.rows.length > 0 ? existingRes.rows[0].quantity : 0;

        if (currentInCart + quantity > stock) {
            return res.status(400).json({ error: `В наличии только ${stock} шт.` });
        }

        const totalRes = await pool.query(
            'SELECT COALESCE(SUM(quantity), 0) as total FROM cart WHERE user_id = $1',
            [user_id]
        );
        if (Number(totalRes.rows[0].total) + quantity > 10) {
            return res.status(400).json({ error: 'Общее количество товаров в корзине не может превышать 10' });
        }

        await pool.query(
            `INSERT INTO cart (user_id, service_id, quantity)
             VALUES ($1, $2, $3)
             ON CONFLICT (user_id, service_id)
             DO UPDATE SET quantity = cart.quantity + EXCLUDED.quantity`,
            [user_id, service_id, quantity]
        );
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/cart/:id', async (req, res) => {
    try {
        const { quantity } = req.body;
        if (quantity > 10) return res.status(400).json({ error: 'Максимум 10 штук' });
        const cartRes = await pool.query(
            'SELECT c.service_id, s.stock FROM cart c JOIN services s ON c.service_id = s.id WHERE c.id = $1',
            [req.params.id]
        );
        if (cartRes.rows.length === 0) return res.status(404).json({ error: 'Не найдено' });
        if (quantity > cartRes.rows[0].stock) {
            return res.status(400).json({ error: `В наличии только ${cartRes.rows[0].stock} шт.` });
        }
        await pool.query('UPDATE cart SET quantity = $1 WHERE id = $2', [quantity, req.params.id]);
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.delete('/cart/:id', async (req, res) => {
    try {
        await pool.query('DELETE FROM cart WHERE id = $1', [req.params.id]);
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.delete('/cart/user/:userId', async (req, res) => {
    try {
        await pool.query('DELETE FROM cart WHERE user_id = $1', [req.params.userId]);
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.post('/orders', async (req, res) => {
    const client = await pool.connect();
    try {
        const { user_id, address, delivery_date } = req.body;
        if (!delivery_date) return res.status(400).json({ error: 'Не указана дата доставки' });
        const today = new Date(); today.setHours(0, 0, 0, 0);
        if (new Date(delivery_date) < today) return res.status(400).json({ error: 'Дата доставки не может быть в прошлом' });

        const ordersTodayRes = await client.query(
            `SELECT COUNT(*) AS cnt FROM orders
             WHERE user_id = $1 AND DATE(created_at) = CURRENT_DATE`,
            [user_id]
        );
        if (Number(ordersTodayRes.rows[0].cnt) >= MAX_ORDERS_PER_DAY) {
            return res.status(400).json({ error: `Нельзя оформить больше ${MAX_ORDERS_PER_DAY} заказов в день` });
        }

        await client.query('BEGIN');

        const cartItems = await client.query(
            `SELECT c.service_id, c.quantity, s.stock, s.name
             FROM cart c JOIN services s ON c.service_id = s.id WHERE c.user_id = $1`,
            [user_id]
        );
        if (cartItems.rows.length === 0) {
            await client.query('ROLLBACK');
            return res.status(400).json({ error: 'Корзина пуста' });
        }
        for (const item of cartItems.rows) {
            if (item.quantity > item.stock) {
                await client.query('ROLLBACK');
                return res.status(400).json({ error: `Товара "${item.name}" в наличии только ${item.stock} шт.` });
            }
        }

        const userRes = await client.query('SELECT discount_percent, first_order_done FROM users WHERE id = $1', [user_id]);
        const userDiscount = userRes.rows[0].first_order_done ? 0 : Number(userRes.rows[0].discount_percent);

        const sumRes = await client.query(
            `SELECT COALESCE(SUM(s.price * c.quantity * (1 - LEAST(75, s.discount_percent + $2) / 100)), 0) AS total
             FROM cart c JOIN services s ON c.service_id = s.id WHERE c.user_id = $1`,
            [user_id, userDiscount]
        );
        const total = sumRes.rows[0].total;

        const orderRes = await client.query(
            `INSERT INTO orders (user_id, address, delivery_date, total)
             VALUES ($1, $2, $3, $4) RETURNING id`,
            [user_id, address, delivery_date, total]
        );
        const orderId = orderRes.rows[0].id;

        await client.query(
            `INSERT INTO order_items (order_id, service_id, quantity, price)
             SELECT $1, c.service_id, c.quantity, s.price
             FROM cart c JOIN services s ON c.service_id = s.id WHERE c.user_id = $2`,
            [orderId, user_id]
        );

        for (const item of cartItems.rows) {
            await client.query('UPDATE services SET stock = stock - $1 WHERE id = $2', [item.quantity, item.service_id]);
        }

        await client.query('DELETE FROM cart WHERE user_id = $1', [user_id]);
        await client.query('UPDATE users SET first_order_done = TRUE WHERE id = $1', [user_id]);

        await client.query('COMMIT');
        res.json({ id: orderId, total });
    } catch (err) {
        await client.query('ROLLBACK');
        res.status(500).json({ error: err.message });
    } finally { client.release(); }
});

router.get('/orders/user/:userId', async (req, res) => {
    try {
        const ordersRes = await pool.query(
            `SELECT id, address, delivery_date, status, total, created_at
             FROM orders WHERE user_id = $1 ORDER BY created_at DESC`,
            [req.params.userId]
        );
        const orders = ordersRes.rows;
        for (const order of orders) {
            const itemsRes = await pool.query(
                `SELECT oi.quantity, oi.price, s.name AS service_name
                 FROM order_items oi JOIN services s ON oi.service_id = s.id WHERE oi.order_id = $1`,
                [order.id]
            );
            order.items = itemsRes.rows;
        }
        res.json(orders);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.get('/orders', requireAdmin, async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT o.id, o.address, o.delivery_date, o.status, o.total, o.created_at,
                    COALESCE(u.name, 'Удалённый пользователь') AS user_name,
                    COALESCE(u.email, '—') AS email
             FROM orders o LEFT JOIN users u ON o.user_id = u.id ORDER BY o.created_at DESC`
        );
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/orders/:id/status', requireAdmin, async (req, res) => {
    try {
        const { status } = req.body;
        const current = await pool.query('SELECT status FROM orders WHERE id = $1', [req.params.id]);
        if (current.rows.length > 0 && current.rows[0].status === 'Оплачен' && status === 'Ожидает оплаты') {
            return res.status(403).json({ error: 'Нельзя изменить статус с "Оплачен" на "Ожидает оплаты"' });
        }
        await pool.query('UPDATE orders SET status = $1 WHERE id = $2', [status, req.params.id]);
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.delete('/orders/:id', requireAdmin, async (req, res) => {
    return res.status(403).json({ error: 'Удаление заказов запрещено' });
});

router.get('/reviews/service/:serviceId', async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT r.id, r.user_id, r.rating, r.comment, r.created_at, r.updated_at,
                    r.is_deleted, r.delete_reason,
                    COALESCE(u.name, 'Удалённый пользователь') AS user_name
             FROM reviews r LEFT JOIN users u ON r.user_id = u.id
             WHERE r.service_id = $1 ORDER BY r.created_at DESC`,
            [req.params.serviceId]
        );
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.get('/reviews', requireAdmin, async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT r.id, r.user_id, r.service_id, r.rating, r.comment,
                    r.created_at, r.updated_at, r.is_deleted, r.delete_reason,
                    COALESCE(u.name, 'Удалённый пользователь') AS user_name,
                    COALESCE(u.email, '—') AS user_email,
                    COALESCE(s.name, 'Удалённый товар') AS service_name
             FROM reviews r
             LEFT JOIN users u ON r.user_id = u.id
             LEFT JOIN services s ON r.service_id = s.id
             ORDER BY r.created_at DESC`
        );
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.post('/reviews', async (req, res) => {
    try {
        const { user_id, service_id, rating, comment } = req.body;
        if (!user_id) return res.status(401).json({ error: 'Только авторизованные пользователи' });
        if (!comment || !comment.trim()) return res.status(400).json({ error: 'Отзыв не может быть пустым' });
        if (comment.trim().length < 5) return res.status(400).json({ error: 'Отзыв должен быть не короче 5 символов' });

        const existing = await pool.query(
            'SELECT id FROM reviews WHERE user_id = $1 AND service_id = $2', [user_id, service_id]
        );
        if (existing.rows.length > 0) return res.status(400).json({ error: 'Вы уже оставляли отзыв на этот товар' });

        const badWord = checkCensorship(comment);
        if (badWord) {
            console.log(`Цензура: пользователь ${user_id} пытался использовать "${badWord}"`);
            return res.status(400).json({
                error: 'Отзыв содержит недопустимые слова. Пожалуйста, соблюдайте правила общения.'
            });
        }

        await pool.query(
            `INSERT INTO reviews (user_id, service_id, rating, comment) VALUES ($1, $2, $3, $4)`,
            [user_id, service_id, rating, comment.trim()]
        );
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/reviews/:id', async (req, res) => {
    try {
        const { user_id, rating, comment } = req.body;
        if (!comment || !comment.trim()) return res.status(400).json({ error: 'Отзыв не может быть пустым' });
        if (comment.trim().length < 5) return res.status(400).json({ error: 'Отзыв должен быть не короче 5 символов' });

        const badWord = checkCensorship(comment);
        if (badWord) {
            console.log(`Цензура (edit): пользователь ${user_id} пытался использовать "${badWord}"`);
            return res.status(400).json({
                error: 'Отзыв содержит недопустимые слова. Пожалуйста, соблюдайте правила общения.'
            });
        }

        const ownerRes = await pool.query('SELECT user_id FROM reviews WHERE id = $1', [req.params.id]);
        if (ownerRes.rows.length === 0) return res.status(404).json({ error: 'Отзыв не найден' });
        if (Number(ownerRes.rows[0].user_id) !== Number(user_id)) {
            return res.status(403).json({ error: 'Можно редактировать только свой отзыв' });
        }

        await pool.query(
            'UPDATE reviews SET rating = $1, comment = $2, updated_at = NOW() WHERE id = $3',
            [rating, comment.trim(), req.params.id]
        );
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/reviews/:id/admin', requireAdmin, async (req, res) => {
    try {
        const { rating, comment } = req.body;
        if (!comment || comment.trim().length < 5) {
            return res.status(400).json({ error: 'Отзыв не короче 5 символов' });
        }
        const badWord = checkCensorship(comment);
        if (badWord) {
            return res.status(400).json({ error: `Отзыв содержит недопустимое слово: "${badWord}"` });
        }
        await pool.query(
            'UPDATE reviews SET rating = $1, comment = $2, updated_at = NOW() WHERE id = $3',
            [rating, comment.trim(), req.params.id]
        );
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.delete('/reviews/:id', requireAdmin, async (req, res) => {
    try {
        const { reason } = req.body;
        await pool.query(
            'UPDATE reviews SET is_deleted = TRUE, delete_reason = $1 WHERE id = $2',
            [reason || 'Удалено за нарушение политики', req.params.id]
        );
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.get('/users', requireAdmin, async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT u.id, u.email, u.name, u.phone, u.default_address,
                    u.discount_percent, u.role_id,
                    COALESCE(r.title, 'Пользователь') AS role_title
             FROM users u LEFT JOIN roles r ON u.role_id = r.id ORDER BY u.id`
        );
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/users/:id', requireAdmin, async (req, res) => {
    return res.status(403).json({ error: 'Изменение данных пользователей запрещено' });
});

router.delete('/users/:id', requireAdmin, async (req, res) => {
    return res.status(403).json({ error: 'Удаление пользователей запрещено' });
});

router.put('/profile/:id', async (req, res) => {
    try {
        const { name, email, phone, default_address } = req.body;
        const nameErr = validateName(name);
        if (nameErr) return res.status(400).json({ error: nameErr });
        if (phone && !PHONE_REGEX.test(phone)) return res.status(400).json({ error: 'Неверный формат телефона' });
        await pool.query(
            `UPDATE users SET name=$1, email=$2, phone=$3, default_address=$4 WHERE id=$5`,
            [name, email, phone, default_address, req.params.id]
        );
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

router.put('/profile/:id/password', async (req, res) => {
    try {
        const { old_password, new_password } = req.body;
        const check = await pool.query(
            'SELECT id FROM users WHERE id = $1 AND password = $2', [req.params.id, old_password]
        );
        if (check.rows.length === 0) return res.status(400).json({ error: 'Неверный старый пароль' });
        await pool.query('UPDATE users SET password = $1 WHERE id = $2', [new_password, req.params.id]);
        res.json({ success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;