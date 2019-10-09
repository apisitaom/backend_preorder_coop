const router = require('express').Router();
const shipping = require('../services/Shipping');

router.post('/recieve', shipping.customerreceive); // CUSTOMER
router.post('/seller/shipping', shipping.sellershipping); // SELLER
router.post('/admin/shipping', shipping.adminshipping); // ADMIN

module.exports = router;