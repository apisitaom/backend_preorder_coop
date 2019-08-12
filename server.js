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
// app.listen(port,'0.0.0.0',()=>{
//     console.log(`Backend running on port ${port}`)
// })
app.listen(port,()=>{
    console.log(`Backend running on port `+port)
})