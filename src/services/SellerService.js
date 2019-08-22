const con = require('../configdb/config')
const Helper = require('../lib/Helper')
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
      console.log(value)
      const response = {
        status : "200",
        message : "success",
        result : token
        }
      return res.status(200).send(response)
    }catch(error){
    if (error.routine === '_bt_check_unique') {
      const response = {
        status : "400",
        message : "User with that EMAIL already exist"
        }
        return res.status(400).send(response)
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
       const response = {
        status : "200",
        message : "success",
        result : token
        }
       return res.status(200).send(response);
    }catch(error){
      const response = {
        status : "200",
        message : "login false"
        }
        return res.status(400).send(response);
    }
   },
   async getall (req,res){
     const sql = 'select * from seller'

     try{
      const { rows } = await con.pool.query(sql)
      const response = {
        status : "200",
        result : rows
        }
      return res.status(200).send(response)
     }catch(error){
      const response = {
        status : "400",
        message : "error"
        }
      return res.status(400).send(response)
     }
   }
}


module.exports = Seller
