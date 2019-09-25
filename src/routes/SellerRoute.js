const router = require('express').Router();
const seller = require('../services/Seller');
const img  =require('../lib/ImageUpload');
const optionvalue = require('../services/Optionvalue');
const product = require('../services/Product');
const preorder = require('../services/Preorder');
const order = require('../services/Order');
const auth = require('../lib/Auth');

router.get('/',(req,res)=>{res.json('SELLER ROUTER')});
router.get('/popup/:id',product.Product.getPopup);
router.get('/products/:id', preorder.getProduct);
router.get('/preproduct/:id', preorder.getProductPreorder);
router.get('/list/:id',seller.shopinfo);
router.get('/preorder',preorder.getProduct);
router.get('/preorder/:id',preorder.getProductDetail);

router.post('/register',img.upload,seller.insert);
router.post('/edit',auth.sellerVerifyToken,img.upload,seller.updateSeller);
router.post('/login',seller.login);
router.post('/optionvalue',img.upload,optionvalue.optionValue.insert);
router.post('/preorder',preorder.insertPreorder);
router.post('/orders/:id', order.getOrderDetail);

module.exports = router;