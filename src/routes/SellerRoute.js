const router = require('express').Router()
//SELLER
const seller = require('../services/SellerService')
//LIB IMAGE
const img  =require('../lib/ImageUpload')
//OPTION VALUE
const optionvalue = require('../services/OptionvalueService')
//PEODUCT
const product = require('../services/ProductService')
//PROORDER
const preorder = require('../services/PreorderService')
//ORDER
const order = require('../services/OrderService')

router.get('/',(req,res)=>{
    res.json('SELLER ROUTER')
})

//REGISTER-SALER    
router.post('/register',img.upload,seller.insert)
router.post('/edit',img.upload,seller.updateSeller)
//LOGIN-SALER
router.post('/login',seller.login)

//ADD PRODUCT-SALER
router.post('/optionvalue',img.upload,optionvalue.optionValue.insert)

//PRODUCT(popup)-SALER-GET
router.get('/popup/:id',product.Product.getPopup)

//PRODUCTS LIST SELLER
router.get('/products/:id', preorder.Preorder.getProduct)

//SHOPINFO-SALER
router.get('/shopinfo/:id',seller.shopinfo)

//ORDERLIST-SALER
router.post('/orderlistsaler',seller.orderlist_saler)

//PREORDER
router.get('/preorder',preorder.Preorder.getProduct)
router.get('/preorder/:id',preorder.Preorder.getProductDetail)
router.post('/preorder',preorder.Preorder.insertPreorder)

//ORDER
router.post('/orders/:id', order.Order.getOrderDetail)

//======================Chapter 2 ======================//

// router.get('/lists',seller.shopCustomer);

module.exports = router