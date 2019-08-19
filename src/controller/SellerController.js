const con = require('../config/config')
const Helper = require('./Helper')
//MOMENT TIME
const moment = require('moment')
//INSERT TO SELLER 
const Seller  = {
  async insert (req,res){
    if(!req.body.email || !req.body.password){
      return res.status(400).send({'message':'missing values email or password'});
    }
    if(!Helper.Helper.isValidEmail(req.body.email)){
      return res.status(400).send({'message':'missing pattern email'});
  }    
    console.log('AJSBD!@&*$^!@*(#&&!@(*$U!K@$!@$')
    console.log(req)
    const {shopname,address,subdistrict,district,province,zipcode,phone,email,password,taxid,bankname,accountname,accountnumber,promptpayname,promptpaynumber} = req.body
    const insertBank = 'INSERT INTO bank(createdate,active,datemodify,bankname,bankaccountname,banknumber) VALUES($1,$2,$3,$4,$5,$6) returning bankid'
    const insertPromptpay = 'INSERT INTO promptpay(createdate,active,datemodify,promptpayname,promptpaynumber) VALUES($1,$2,$3,$4,$5) returning promptpayid'
    const activeStatus = true
    const hashPassword = Helper.Helper.hashPassword(password);
    const today = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    const valuePromptpay = [today,activeStatus,today,promptpayname,promptpaynumber]
    const valueBank = [today,activeStatus,today,bankname, accountname,accountnumber]
    try{
      await con.pool.query('BEGIN')
      const rowBankNew = await con.pool.query(insertBank, valueBank)
      const rowPromptpayNew = await con.pool.query(insertPromptpay, valuePromptpay)
      const insertSeller = `INSERT INTO seller(active,datemodify,sellername,address,subdistrict,district,zipcode,province,phonenumber,email,sellerpassword,taxid,photo,bankid,promptpayid) 
      VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15) returning sellerid`
      const value = [activeStatus,today,shopname,address,subdistrict,district,zipcode,province,phone,email,hashPassword,taxid,req.files[0].filename,rowBankNew.rows[0].bankid,rowPromptpayNew.rows[0].promptpayid]
      const result = await con.pool.query(insertSeller,value)
      await con.pool.query('COMMIT')
      const token = Helper.Helper.generateToken(result.rows[0].sellerid);
      // return res.status(200).send({token});
      console.log(value)
      res.end('success')
    }catch(error){
    if (error.routine === '_bt_check_unique') {
        return res.status(400).send({ 'message': 'User with that EMAIL already exist' })
      }
      throw error
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
