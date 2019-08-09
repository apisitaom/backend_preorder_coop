//IMAGE
const multer = require('multer')
const path = require('path')
//PSQL
const con = require('../config/config')
//IMAGE
const storage = multer.diskStorage({
    destination: ('./public/uploads/'),
  
     filename: async function (req, file, cb) {
        cb(null, file.fieldname + '-' +new Date().getTime().toString()+ path.extname(file.originalname))

        const text =  file.fieldname + '-' +new Date().getTime().toString()+ path.extname(file.originalname)
        
        console.log(file)
        //PICTURE TABLE
         await con.pool.query('INSERT INTO picture(picture) VALUES($1)',[text]);
    }
  })
  const upload = multer({
    storage: storage,
    limits:{
        fileSize: 1000000
    }
  }).single('picture')

exports.upload = upload