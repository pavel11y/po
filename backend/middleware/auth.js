module.exports = {
    requireAuth: (req, res, next) => {
        const userId = req.query.current_user_id || req.body.current_user_id
        if(!userId){
            return res.status(401).json({error: 'Требуется авторизация'})
        }
        req.userId = userId
        next()
    },

    requireAdmin: async (req, res, next) =>{
        const pool = require('../config/db')
        const userId = req.query.current_user_id || req.body.current_user_id;
        try {
            const result = await pool.query(
                `SELECT r.title FROM users u
                    JOIN roles r ON u.role_id = r.id
                    WHERE u.id = $1`,
                [userId]
            )
            if (result.rows.length === 0 || result.rows[0].title !== 'Администратор'){
                return res.status(403).json({error: 'Доступ только для администратора'})
            }
            next()
        }
        catch(err){
            res.status(500).json({error: err.message})
        }
    }
}