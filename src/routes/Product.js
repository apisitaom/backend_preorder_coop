const router = require('express').Router()
const product = require('../services/ProductService');

router.get('/', (req, res, next)=>{
    res.json('PRODUCT ROUTER')
});

router.get('/list', product.cartCustomer);

module.exports = router