const express = require('express')
const cors = require('cors')
require('dotenv').config()

const routes = require('./routes')

const app = express()
app.use(cors())
app.use(express.json())

app.use('/api', routes)

app.use((err, req, res, next) => {
    console.error(err)
    res.status(500).json({ error: 'Технические работы. Попробуйте позже.' })
})

const PORT = process.env.PORT || 3001
app.listen(PORT, () => {
    console.log(`Сервер Lunar Estates запущен на порту ${PORT}`)
})