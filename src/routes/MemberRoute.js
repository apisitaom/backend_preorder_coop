const router = require('express').Router();
const member = require('../services/Member');
const img = require('../lib/ImageUpload');
const auth = require('../lib/Auth');

router.get('/', (req, res, next)=>{res.json('MEMBER ROUTER')});
router.get('/lists',auth.userVerifyToken ,member.getProfileMember);
router.get('/pay', member.getPaymentCustomer);

router.post('/add',img.upload, member.registerMember);
router.post('/edit',img.upload,member.updateMember);
router.post('/login',member.logInMember);
router.post('/pay',img.upload, member.paymentCustomer);

module.exports = router;