const router = require('express').Router();
const product = require('../services/Product');
const img = require('../lib/ImageUpload');
const auth = require('../lib/Auth');

router.get('/', (req, res, next)=>{res.json('PRODUCT ROUTER')});
router.get('/lists', product.homepageCustomer);
router.get('/pay',auth.userVerifyToken,product.getCartCustomer);
router.get('/list' ,auth.sellerVerifyToken,product.shopCustomer);
router.get('/list/:id', product.getProduct);

router.post('/add', product.insertProductHomepage);
router.post('/buy',auth.userVerifyToken,img.upload, product.cartCustomer);
router.post('/adds', product.preOrder);

module.exports = router;