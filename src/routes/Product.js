const router = require('express').Router()
const product = require('../services/ProductService');

router.get('/', (req, res, next)=>{
    res.json('PRODUCT ROUTER')
});

// router.get('/list', product.cartCustomer);

router.get('/lists', product.homepageCustomer);

router.post('/add', product.insertProductHomepage);

router.get('/list', product.shopCustomer);

module.exports = router