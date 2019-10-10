const router = require('express').Router();
const img = require('../lib/ImageUpload');
const auth = require('../lib/Auth');
const payment = require('../services/payment');

router.get('/', (req, res, next)=>{res.json('PAYMENT ROUTE')});
router.get('/lists',payment.lists);

router.post('/add',img.upload, payment.add);
module.exports = router;