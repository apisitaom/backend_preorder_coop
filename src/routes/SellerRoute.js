const router = require('express').Router();
const seller = require('../services/Seller');
const img  =require('../lib/ImageUpload');
const optionvalue = require('../services/Optionvalue');
const product = require('../services/Product');
const preorder = require('../services/Preorder');
const order = require('../services/Order');

router.get('/',(req,res)=>{res.json('SELLER ROUTER')});
router.post('/register',img.upload,seller.insert);
router.post('/edit',img.upload,seller.updateSeller);
router.post('/login',seller.login);
router.post('/optionvalue',img.upload,optionvalue.optionValue.insert);
router.post('/preorder',preorder.Preorder.insertPreorder);
router.post('/orders/:id', order.Order.getOrderDetail);

router.get('/popup/:id',product.Product.getPopup);
router.get('/products/:id', preorder.Preorder.getProduct);
router.get('/list',seller.shopinfo);
router.get('/preorder',preorder.Preorder.getProduct);
router.get('/preorder/:id',preorder.Preorder.getProductDetail);

module.exports = router;