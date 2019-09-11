const router = require('express').Router()
const member = require('../services/Member');
const img = require('../lib/ImageUpload');

const auth = require('../lib/Auth');

router.get('/', (req, res, next)=>{
    res.json('MEMBER ROUTER')
});
 
// Profile-customer
router.post('/add',img.upload, member.registerMember);
router.get('/lists',auth.userVerifyToken ,member.getProfileMember);
router.post('/edit',img.upload,member.updateMember);
// login-custimer
router.post('/login',member.logInMember);

module.exports = router;