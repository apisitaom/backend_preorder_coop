const router = require('express').Router();
const admin = require('../services/Admin');
const dashboard = require('../services/Dashboard')
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
router.get('/sales', dashboard.sales)
router.get('/amount', dashboard.totalAmount)
router.get('/customer', dashboard.totalCustomer)
router.get('/sellerstop/:top', dashboard.topTenSeller)
router.get('/sellerstop', dashboard.topTenSeller)
router.get('/provinces', dashboard.proviceLists)

router.post('/sellerstop', dashboard.topTenSeller)
router.post('/provinces', dashboard.proviceLists)
router.post('/user', dashboard.users)
router.post('/graph', dashboard.graph)
router.post('/sellers/:id', updateSellerStatus)
router.post('/orders/:id', updatePaymentStatus)

router.post('/login', login)
router.post('/register', createAdmin)

module.exports = router
