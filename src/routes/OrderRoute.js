const router = require('express').Router();
const img = require('../lib/ImageUpload');
const auth = require('../lib/Auth');
const order = require('../services/Order');

router.get('/', (req, res, next) => {res.json('ORDER ROUTE')});
router.get('/lists', order.lists);
router.get('/list/:id', order.list);

router.post('/add', order.add);

module.exports = router;