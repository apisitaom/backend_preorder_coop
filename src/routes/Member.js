const router = require('express').Router()
const member = require('../services/Member');
const img = require('../lib/ImageUpload');
router.get('/', (req, res, next)=>{
    res.json('MEMBER ROUTER')
});
 
// Profile-customer
router.post('/add',img.upload, member.registerMember);
router.get('/lists', member.getProfileMember);
router.put('/edit',img.upload,member.updateMember);
// login-custimer
router.post('/login',member.logInMember);

module.exports = router;