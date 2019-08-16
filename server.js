const express = require('express')
const bodyParser = require('body-parser')
const app = express() 
//USER
const admin = require('./src/controller/AdminController')
//SELLER 
const seller = require('./src/controller/SellerController')
//IMAGE CONTROLLER
const image = require('./src/controller/ImageController')
//OPTION VALUES
const optionvalue = require('./src/controller/OptionvalueController')
//PRODUCT
const product = require('./src/controller/ProductController')
//CORE
const cors = require('cors')
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


app.listen(port,()=>{
    console.log(`Backend running on port `+port)
})