const router = require('express').Router();
const product = require('../services/Product');
const img = require('../lib/ImageUpload');

router.get('/', (req, res, next)=>{res.json('PRODUCT ROUTER')});
router.get('/lists', product.homepageCustomer);
router.get('/pay',product.getCartCustomer);
router.get('/list', product.shopCustomer);
router.get('/list/:id', product.getProduct);

router.post('/add', product.insertProductHomepage);
router.post('/buy',img.upload, product.cartCustomer);

module.exports = router;