const router = require('express').Router();
const member = require('../services/Member');
const img = require('../lib/ImageUpload');
const auth = require('../lib/Auth');

router.get('/', (req, res, next)=>{res.json('MEMBER ROUTE')});
router.get('/lists',auth.userVerifyToken ,member.list);

router.post('/add',img.upload, member.add);
router.post('/edit',auth.userVerifyToken,img.upload,member.edit);
router.post('/login',member.login);

module.exports = router;