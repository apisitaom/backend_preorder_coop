const router = require('express').Router();
const order = require('../services/Order');

router.get('/', (req, res, next) => {res.json('ORDER ROUTE')});
router.get('/lists', order.lists);
router.get('/admin/order', order.adminorder);

router.post('/add', order.add);

module.exports = router;