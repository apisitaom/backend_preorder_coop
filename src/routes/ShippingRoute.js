const router = require('express').Router();
const shipping = require('../services/Shipping');

router.post('/recieve', shipping.customerreceive); // CUSTOMER
router.post('/seller/shipping', shipping.sellershipping); // SELLER

module.exports = router;