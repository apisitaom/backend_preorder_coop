const router = require('express').Router();
const seller = require('../services/Seller');
const img  =require('../lib/ImageUpload');
const optionvalue = require('../services/Optionvalue');
const product = require('../services/Product');
const preorder = require('../services/Preorder');

router.get('/',(req,res)=>{res.json('SELLER ROUTE')});
router.get('/popup/:id',product.Product.getPopup);
router.get('/products/:id', preorder.getProduct);
router.get('/preproduct/:id', preorder.getProductPreorder);
router.get('/list/:id',seller.lists);
router.get('/preorder',preorder.getProduct);
router.get('/preorder/:id',preorder.getProductDetail);
router.get('/all', seller.all);
router.get('/buy', seller.buy);
router.get('/buyid/:id', seller.buyid);

router.post('/register',img.upload,seller.insert);
router.post('/edit',img.upload,seller.edit);
router.post('/login',seller.login);
router.post('/optionvalue',img.upload,optionvalue.insert);
router.post('/preorder',preorder.insertPreorder);
router.post('/role',seller.Role);    

module.exports = router;