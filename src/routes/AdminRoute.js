const router = require('express').Router();
const admin = require('../services/Admin');
const dashboard = require('../services/Dashboard')
const order = require('../services/Order')
const { 
    updatePaymentStatus, 
    updateSellerStatus, 
    login,
    createAdmin, 
    sellers,
    orders
 }= require('../services/Admin')
 
router.get('/', (req, res) => {
    res.json({ info: `welcome to admin` })
});

router.post('/add',admin.createAdmin);
router.post('/login', admin.login);

router.get('/order', order.adminorder);
router.get('/orders', orders)
router.get('/orders/:id', orders)
router.get('/sellers', sellers)
router.get('/sellers/:id', sellers)
router.get('/sales', dashboard.sales)
router.get('/amount', dashboard.totalAmount)
router.get('/seller', dashboard.totalSeller)
router.get('/customer', dashboard.totalCustomer)
router.get('/sellerstop/:top', dashboard.topTenSeller)
router.get('/sellerstop', dashboard.topTenSeller)
router.get('/provinces', dashboard.proviceLists)

router.post('/customerGroup', dashboard.customerGroup)
router.post('/sellerstop', dashboard.topTenSeller)
router.post('/provinces', dashboard.proviceLists)
router.post('/user', dashboard.users)
router.post('/graph', dashboard.graph)
router.post('/sellers/:id', updateSellerStatus)
router.post('/orders/:id', updatePaymentStatus)

router.post('/login', login)
router.post('/register', createAdmin)

module.exports = router