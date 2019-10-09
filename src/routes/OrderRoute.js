const router = require('express').Router();
const order = require('../services/Order');

router.get('/', (req, res, next) => {res.json('ORDER ROUTE')});
router.get('/lists', order.lists);

router.post('/add', order.add);

module.exports = router;