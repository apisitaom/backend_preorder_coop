const router = require('express').Router();
const member = require('../services/Member');
const img = require('../lib/ImageUpload');
const auth = require('../lib/Auth');

router.get('/', (req, res)=>{res.json('MEMBER ROUTE')});
router.get('/lists',auth.userVerifyToken ,member.getProfileMember);

router.post('/add',img.upload, member.registerMember);
router.post('/edit',auth.userVerifyToken,img.upload,member.updateMember);
router.post('/login',member.logInMember);

module.exports = router;