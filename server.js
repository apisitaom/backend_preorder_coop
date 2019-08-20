const express = require('express')
const bodyParser = require('body-parser')
const app = express() 

//USER
const admin = require('./src/services/AdminService')
//SELLER 
const seller = require('./src/services/SellerService')
//IMAGE CONTROLLER
const image = require('./src/services/ImageController')
//OPTION VALUES
const optionvalue = require('./src/services/OptionvalueService')
//PRODUCT
const product = require('./src/services/ProductService')
//CORE
const cors = require('cors')
//PREORDER
const preorder = require('./src/services/PreorderService')
//PORT 
const port = 4000

app.use(cors())

app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({extended: true})
)

app.get('/',(req,res) =>{
    res.json({info : `GET START ${port}`})
})

//EXPRESS PUBLIC FILE
app.use(express.static('public'));
app.use('/images', express.static(__dirname + '/public/uploads'));

//USER(ADMIN)
app.post('/admin/login',admin.Admin.login)
app.post('/admin/register',admin.Admin.createAdmin)

//register-saler
app.post('/api/register/seller',image.upload,seller.insert)
//saler-login
app.post('/api/login/seller',seller.login)

//add product-saler
app.post('/optionvalue',optionvalue.optionValue.insert)

//product(popup)-saler-get
app.get('/product/popup/:id',product.Product.getPopup)

//PRODUCT
app.get('/products', product.Product.getMaxMin)
//PREORDER
app.get('/preorders', preorder.Preorder.getProduct)
app.get('/preorder/:id', preorder.Preorder.getProductDetail)
app.post('/preorder', preorder.Preorder.insertPreorder)

app.listen(port,()=>{
    console.log(`Backend running on port `+port)
})