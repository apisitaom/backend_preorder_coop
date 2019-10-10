const router = require('express').Router();
const shipping = require('../services/Shipping');

router.get('/lists', shipping.lists); // ADMIN
router.get('/recieve', shipping.recieve); // ADMIN

router.post('/recieve', shipping.customerreceive); // CUSTOMER
router.post('/seller/shipping', shipping.sellershipping); // SELLER
router.post('/edit', shipping.edit);

module.exports = router;