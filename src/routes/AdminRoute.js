const router = require('express').Router();
const admin = require('../services/Admin');

router.get('/',(req,res)=>{res.json('ADMIN ROUTE')});

router.post('/add',admin.add);
router.post('/login', admin.login);

module.exports = router;