const moment = require('moment')
const db = require('../configdb/configDB');
const successMessage = require('../lib/successMessage');
const errorMessage = require('../lib/errorMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');

    async function login(req,res){
     if(!req.body.email || !req.body.password){
        return Responce.resError(res, errorMessage.saveError);
     }
     if(!helper.Helper.isValidEmail(req.body.email)){
       return Responce.resError(res, errorMessage.saveError);
     }
     const text = 'SELECT * FROM admin WHERE email = $1';
     try{
        const { rows } = await db.query(text,[req.body.email]);
        if(!rows[0]){
          return Responce.resError(res, errorMessage.saveError);
        }
        if (!helper.Helper.comparePassword(rows[0].password, req.body.password)){
            return Responce.resError(res, errorMessage.saveError);
        }
        const mergedata = {
          email: rows[0].email
        }
        const tranfrom = {
          id: rows[0].id
        }
        const token = helper.Helper.generateToken(tranfrom);
        return Responce.resSuccuessToken(res, successMessage.success,mergedata , token);
     }catch(error){
        return Responce.resError(res, errorMessage.saveError); 
     }
    }
    async function add(req, res) {
        if (!req.body.email || !req.body.password) {
          return Responce.resError(res, errorMessage.saveError);
        }
        if (!helper.Helper.isValidEmail(req.body.email)) {
          return Responce.resError(res, errorMessage.saveError);
        }
        const hashPassword = helper.Helper.hashPassword(req.body.password);
        const createQuery = `INSERT INTO
          admin( email, password, created_date, modified_date)
          VALUES( $1, $2, $3, $4)
          returning *`;
        const values = [
          req.body.email,
          hashPassword,
          date,
          date
        ];
        try {
          await db.query(createQuery, values);

          return Responce.resSuccess(res, successMessage.success);
        } catch(error) {
          if (error.routine === '_bt_check_unique') {
            return Responce.resError(res, errorMessage.emailInvalid);
          }
          return Responce.resError(res, errorMessage.saveError);
        }
      } 

module.exports = {
  login,
  add
}


