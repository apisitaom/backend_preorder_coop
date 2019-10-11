const router = require('express').Router();
const product = require('../services/Product');
const img = require('../lib/ImageUpload');
const auth = require('../lib/Auth');

router.get('/', (req, res, next)=>{res.json('PRODUCT ROUTE')});
router.get('/lists', product.homepage);
router.get('/pay',auth.userVerifyToken,product.orderlists);
router.get('/list' ,auth.sellerVerifyToken,product.lists);
router.get('/list/:id', product.getproduct);

router.post('/add', product.addhomepage);
router.post('/buy',auth.userVerifyToken,img.upload, product.orderadd);
router.post('/edit', img.upload ,product.edit);
router.post('/search', product.search);

module.exports = router;