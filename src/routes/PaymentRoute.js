const router = require('express').Router();
const img = require('../lib/ImageUpload');
const payment = require('../services/payment');

router.get('/', (req, res, next)=>{res.json('PAYMENT ROUTE')});
router.get('/lists', payment.lists);
router.get('/list/:id', payment.list);
router.get('/all', payment.adminpaymentlists) // ADMIN

router.post('/add', img.upload, payment.add);
router.post('/pay', payment.adminpaymentadd); // ADMIN

module.exports = router;