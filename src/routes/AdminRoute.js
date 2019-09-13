const router = require('express').Router()

const admin = require('../services/AdminService')

router.get('/',(req,res)=>{
    res.json('ADMIN ROUTER')
})

router.post('/add', admin.add);
router.post('/login', admin.login);

module.exports = router