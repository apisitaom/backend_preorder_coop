const router = require('express').Router()
const product = require('../services/ProductService');
const img = require('../lib/ImageUpload');

router.get('/', (req, res, next)=>{
    res.json('PRODUCT ROUTER')
});

// router.get('/list', product.cartCustomer);

router.get('/lists', product.homepageCustomer);

router.post('/add', product.insertProductHomepage);

router.get('/list', product.shopCustomer);

//productDetail-Customeer
router.get('/list/:id', product.getProduct);

router.post('/buy',img.upload, product.cartCustomer);

router.get('/pay',product.getCartCustomer);

module.exports = router