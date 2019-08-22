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
//TEST GET SELLER
router.get('/get',seller.getall)

//REGISTER-SALER    
router.post('/register',img.upload,seller.insert)

//LOGIN-SALER
router.post('/login',seller.login)

//ADD PRODUCT-SALER
router.post('/optionvalue',optionvalue.optionValue.insert)

//PRODUCT(popup)-SALER-GET
router.get('/popup/:id',product.Product.getPopup)

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

module.exports = router