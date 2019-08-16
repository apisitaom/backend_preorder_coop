const express = require('express')
const bodyParser = require('body-parser')
const app = express()
//USER
const user = require('./src/controller/UserController')
//SELLER 
const seller = require('./src/controller/SellerController')
//IMAGE CONTROLLER
const image = require('./src/controller/ImageController')
//OPTION VALUES
const optionvalue = require('./src/controller/OptionvalueController')
//PRODUCT
const product = require('./src/controller/ProductController')
//PREORDER
const preorder = require('./src/controller/PreorderController')
//PORT 
const port = 4000

app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({extended: true})
)
//EXPRESS PUBLIC FILE
app.use(express.static('public'));
//IMAGE
app.post('/profile', image.upload)
app.post('/test',optionvalue.upload)
//PATH GET images + name picture 
app.use('/images', express.static(__dirname + '/public/uploads'));

app.get('/',(req,res) =>{
    res.json({info : `GET START ${port}`})
})
//USER
app.post('/user/login',user.User.login)
app.post('/user/create',user.User.createUser)
//SELLER
app.post('/seller/register',seller.insert)
app.post('/seller/login',seller.login)
//OPTION VALUE
app.post('/optionvalue',optionvalue.optionValue.insert)
<<<<<<< HEAD
//PRODUCT
app.get('/products', product.Product.getMaxMin)
//PREORDER
app.get('/preorders', preorder.Preorder.getProduct)
app.get('/preorder/:id', preorder.Preorder.getProductDetail)
app.post('/preorder', preorder.Preorder.insertPreorder)

=======
//PRODUCT GET POPUP
app.get('/product/popup',product.Product.getPopup)
>>>>>>> 8c7ca6ad14eea27aafbae8eab257b64b419a2ab4

app.listen(port,()=>{
    console.log(`Backend running on port `+port)
})