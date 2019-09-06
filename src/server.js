const express = require('express')
require('dotenv').config()
const cors = require('cors')
const bodyParser = require('body-parser')
const path = require('path')
//ROUTES
const sellerRoute = require('./routes/SellerRoute')
const adminRoute = require('./routes/AdminRoute')
const productRoute = require('./routes/Product');
const memberRoute = require('./routes/Member');
const app = express()
const port = process.env.PORT || 4000

app.use(cors())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))
app.use(express.static('public'))

app.use((err, req, res, next) => {
    // const clientIp = reqip.getClientIp(req); 
    // let currentDatetime = new Date()
    // let formattedDate = currentDatetime.getFullYear() + "-" + (currentDatetime.getMonth() + 1) + "-" + currentDatetime.getDate() + " " + currentDatetime.getHours() + ":" + currentDatetime.getMinutes() + ":" + currentDatetime.getSeconds() 
    console.log(`${req.path}` + ` <> ${req.ip}` + ` <> ${req.method}`)
    next()
})

app.get('/', (req, res) => {
    res.json({ info: `welcome  to project start on ${port}` })
})

//seLLER ROUTE
app.use('/seller', sellerRoute)
app.use('/admin', adminRoute)
app.use('/product', productRoute);
app.use('/member', memberRoute);
//IMAGE
app.use('/images', express.static(path.join(__dirname + '/../public/uploads')));

app.use((err, req, res, next) => {
    console.log(err)
    if (err.status === 400) {
        err.message = `server error`
    }
    next()
})

app.use((err, req, res, next) => {
    res.status(400).send({
        code: 400,
        msg: err.message
    })
})

app.listen(port, function () {
    console.log(`server run on port ${port}`)
})

