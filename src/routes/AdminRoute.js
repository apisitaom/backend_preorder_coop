const router = require('express').Router()

const admin = require('../services/AdminService')

router.get('/',(req,res)=>{
    res.json('ADMIN ROUTER')
})

//LOGIN ADMIN
router.post('/login',admin.Admin.login)

//REGISTER ADMIN
router.post('/register',admin.Admin.createAdmin)

module.exports = router