const router = require('express').Router();
const admin = require('../services/Admin');

<<<<<<< HEAD
const { 
    updatePaymentStatus, 
    updateSellerStatus, 
    login, 
    getUserData, 
    createAdmin, 
    getUserOneData, 
    sellers,
    orders
 }= require('../services/AdminService')
=======
router.get('/',(req,res)=>{res.json('ADMIN ROUTE')});
>>>>>>> master

router.post('/add',admin.add);
router.post('/login', admin.login);

<<<<<<< HEAD
router.get('/orders', orders)
router.get('/orders/:id', orders)
router.get('/sellers', sellers)
router.get('/sellers/:id', sellers)

router.post('/sellers/:id', updateSellerStatus)
router.post('/orders/:id', updatePaymentStatus)

router.post('/login', login)
router.post('/register', createAdmin)

module.exports = router
=======
module.exports = router;
>>>>>>> master
