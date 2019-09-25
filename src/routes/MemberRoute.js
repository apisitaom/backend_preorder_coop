const router = require('express').Router();
const member = require('../services/Member');
const img = require('../lib/ImageUpload');
const auth = require('../lib/Auth');

router.get('/', (req, res, next)=>{res.json('MEMBER ROUTE')});
router.get('/lists',auth.userVerifyToken ,member.getProfileMember);
// router.get('/pay',auth.userVerifyToken ,member.getPaymentCustomer);

router.post('/add',img.upload, member.registerMember);
router.post('/edit',auth.userVerifyToken,img.upload,member.updateMember);
router.post('/login',member.logInMember);
// router.post('/pay',img.upload, member.paymentCustomer);

module.exports = router;