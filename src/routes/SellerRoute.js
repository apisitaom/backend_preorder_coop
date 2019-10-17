const router = require('express').Router();
const seller = require('../services/Seller');
const img  =require('../lib/ImageUpload');
const optionvalue = require('../services/Optionvalue');
const product = require('../services/Product');
const preorder = require('../services/Preorder');
const dashboard = require('../services/Dashboard')

router.get('/',(req,res)=>{res.json('SELLER ROUTE')});
router.get('/trackno/:id', seller.trackno)
router.get('/popup/:id',product.getPopup);
router.get('/products/:id', preorder.getProduct);
router.get('/preproduct/:id', preorder.getProductPreorder);
router.get('/list/:id',seller.lists);
router.get('/preorder',preorder.getProduct);
router.get('/preorder/:id',preorder.getProductDetail);
router.get('/all', seller.all);
router.get('/buy', seller.buy);
router.get('/products/list/:id', seller.productLists)
router.get('/buyid/:id', seller.buyid);
router.get('/sales/:id', dashboard.sales)
router.get('/amount/:id', dashboard.totalAmount)
router.get('/customer/:id', dashboard.totalCustomer)
router.get('/top/:id', dashboard.topTenProducts)

router.post('/product/sales/lists/:id', dashboard.topTenProducts)
router.post('/product/sales/:id', dashboard.productSale)
router.post('/graph/:id', dashboard.graph)
router.post('/user/:id', dashboard.users)
router.post('/register',img.upload,seller.insert);
router.post('/edit',img.upload,seller.edit);
router.post('/login',seller.login);
router.post('/optionvalue',img.upload,optionvalue.insert);
router.post('/preorder',preorder.insertPreorder);
router.post('/role',seller.role);    

module.exports = router;
