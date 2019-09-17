const express = require('express');
require('dotenv').config();
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
//ROUTES
const sellerRoute = require('./routes/SellerRoute');
const adminRoute = require('./routes/AdminRoute');
const productRoute = require('./routes/ProductRoute');
const memberRoute = require('./routes/MemberRoute');

const app = express();
const port = process.env.PORT || 4000;

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public'));

app.use((req, res, next) => {
    console.log(`serve on path ${req.method} ${req.path}`);
    next();
  });

app.get('/', (req, res) => {
    res.json({ info: `welcome  to project start on ${port}` })
});

//seLLER ROUTE
app.use('/seller', sellerRoute);
app.use('/admin', adminRoute);
app.use('/product', productRoute);
app.use('/member', memberRoute);
//IMAGE
app.use('/images', express.static(path.join(__dirname + '/../public/uploads')));

app.listen(port,  () => {
    console.log(`server run on port ${port}`);
});

