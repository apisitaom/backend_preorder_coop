const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: ('./public/uploads/'),
  filename: function (req, file, cb) {
    cb(null, file.fieldname + '-' + new Date().getTime().toString() + path.extname(file.originalname));
    const text = file.fieldname + '-' + new Date().getTime().toString() + path.extname(file.originalname);
    req.picture = text;
  }
});
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1 * 1024 * 1024 // 2 MB
  },
  fileFilter: function (req, file, callback) {
    var ext = path.extname(file.originalname);
    if(ext !== '.png' && ext !== '.jpg' && ext !== '.gif' && ext !== '.jpeg') {
        return callback(new Error('Only images are allowed'));
    }
    callback(null, true);
}
}).array('picture', 10);

module.exports = { upload }