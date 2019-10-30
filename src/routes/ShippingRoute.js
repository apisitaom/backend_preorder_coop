const router = require('express').Router();
const shipping = require('../services/Shipping');

router.get('/lists', shipping.lists);
router.get('/recieve', shipping.recieve);

router.post('/recieve', shipping.customerreceive);
router.post('/seller/shipping', shipping.sellershipping);
router.post('/edit', shipping.edit);

module.exports = router;