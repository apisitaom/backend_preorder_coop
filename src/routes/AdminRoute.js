const router = require('express').Router();
const admin = require('../services/Admin');

const { 
    updatePaymentStatus, 
    updateSellerStatus, 
    login,
    createAdmin, 
    sellers,
    orders
 }= require('../services/AdminService')
 
router.get('/', (req, res) => {
    res.json({ info: `welcome to admin` })
});

router.post('/add',admin.add);
router.post('/login', admin.login);

router.get('/orders', orders)
router.get('/orders/:id', orders)
router.get('/sellers', sellers)
router.get('/sellers/:id', sellers)

router.post('/sellers/:id', updateSellerStatus)
router.post('/orders/:id', updatePaymentStatus)

router.post('/login', login)
router.post('/register', createAdmin)

module.exports = router
