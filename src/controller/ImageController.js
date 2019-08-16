//IMAGE
const multer = require('multer')
const path = require('path')
//PSQL
const con = require('../config/config')
//SELLER
const Helper = require('./Helper')
const moment = require('moment')
//SELLER
const storage = multer.diskStorage({
    destination: ('./public/uploads/'),
  
     filename: function (req, file, cb) {

      
        cb(null, file.fieldname + '-' +new Date().getTime().toString()+ path.extname(file.originalname))

        const text = file.fieldname + '-' +new Date().getTime().toString()+ path.extname(file.originalname)

        req.picture = text
      }
  }) 

  const upload = multer({
    storage: storage,
    limits:{
        
        fileSize: 1000000

           }
           
  }).array('picture',10);

  module.exports = {upload}