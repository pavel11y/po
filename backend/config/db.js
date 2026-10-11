const {Pool} =  require('pg')
require('dotenv').config()

const pool = new Pool({
    host: process.env.PG_HOST,
    user: process.env.PG_USER,
    password: process.env.PG_PASSWORD,
    database: process.env.PG_DATABASE,
    port: process.env.PG_PORT,
})

pool.connect((err, client, release) => {
    if (err){
        console.error('Ошибка подключения к БД:', err.stack)
    }
    else{
        console.log('Подключение к БД service_shop установлено');
        release();
    }
})

module.exports = pool;