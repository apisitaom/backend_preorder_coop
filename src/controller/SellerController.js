const con = require('../config/config')
const Helper = require('./Helper')
//MOMENT TIME
const moment = require('moment')
//INSERT TO SELLER 
const Seller  = {
  async insert (req,res){
    if(!req.body.email || !req.body.password){
      return res.status(400).send({'message':'missing values 1'});
    }
    if(!Helper.Helper.isValidEmail(req.body.email)){
      return res.status(400).send({'message':'missing data 2 '});
  }    
    const {shopname,address,subdistrict,district,province,zipcode,phone,email,password,taxid,picture,bankid,promptpayid} = req.body
    const hasPassword = Helper.Helper.hashPassword(req.body.password);
    const create = `INSERT INTO seller(createdate,sellername,address,subdistrict,district,province,zipcode,phonenumber,email,sellerpassword,taxid,photo,bankid,promptpayid) 
    VALUES ($1, $2, $3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14) returning *`;
    const createdate = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const value = [createdate, shopname,address,subdistrict,district,province,zipcode,phone,email,hasPassword,taxid,picture,bankid,promptpayid];
    console.log(req.body)

    const hashPassword = Helper.Helper.hashPassword(password);
    console.log(req.body)
    try{
      const {rows} = await con.pool.query(selectCheck,[email])
      if(rows[0]){
        return res.status(400).send({'message':'email is useing'});
      }
      await con.pool.query('BEGIN')
      const rowBankNew = await con.pool.query(insertBank, [today,activeStatus,today,bankname, accountname,accountnumber])
      const rowPromptpayNew = await con.pool.query(insertPromptpay, [today,activeStatus,today,promptpayname,promptpaynumber])
      const insertSeller = `INSERT INTO seller(active,sellername,address,subdistrict,district,zipcode,province,phonenumber,email,sellerpassword,taxid,photo,bankid,promptpayid) 
      VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14) returning sellerid`
      const value = [activeStatus,shopname,address,subdistrict,district,zipcode,province,phone,email,hashPassword,taxid,picture,rowBankNew.rows[0].bankid,rowPromptpayNew.rows[0].promptpayid]
      console.log(value)
      const result = await con.pool.query(insertSeller,value)
      await con.pool.query('COMMIT')
      const token = Helper.Helper.generateToken(result.rows[0].sellerid);
      return res.status(200).send({token});
    }catch(error){
    if (error.routine === '_bt_check_unique') {
        return res.status(400).send({ 'message': 'User with that EMAIL already exist' })
      }
      throw error
    // return res.status(400).send(error);
    }
  },
  //LOGIN
  async login(req,res){
    if(!req.body.email || !req.body.password){
        return res.status(400).send({'message':'Missing value1'})
    }
    if(!Helper.Helper.isValidEmail(req.body.email)){
        return res.status(400).send({'message':'Missing value2'});
    }
    const text = 'SELECT * FROM seller WHERE email = $1';
    try{
       const { rows } = await con.pool.query(text,[req.body.email]);
       if(!rows[0]){
           return res.status(400).send({'message':'Missing value3'});
       }
       if (!Helper.Helper.comparePassword(rows[0].sellerpassword, req.body.password)){
           return res.status(400).send({'message':'Missing value4'});
       }
       const token = Helper.Helper.generateToken(rows[0].id);
       return res.status(200).send({token});
    }catch(error){
        return res.status(400).send(error,{'message':'error'});
    }
   }
}


module.exports = Seller
