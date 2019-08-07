const con = require('../config/config')
//MOMENT TIME
const moment = require('moment')

//INSERT TO SELLER 
const Seller  = {
  async insert (req,res){
    const {shopname,address,subdistrict,district,province,zipcode,phone,email,password,taxid,picture,bankid,promptpayid} = req.body
    const create = `INSERT INTO seller(datetoday,shopname,address,subdistrict,district,province,zipcode,phone,email,password,taxid,picture,bankid,promptpayid) 
    VALUES ($1, $2, $3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14) returning *`;
  const datetoday = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const value = [datetoday, shopname,address,subdistrict,district,province,zipcode,phone,email,password,taxid,picture,bankid,promptpayid];
    console.log(req.body)
    console.log(value)
    try{
      await con.pool.query(create,value);
      console.log(req.body);
      return res.status(200).send({'message':'register seller is succes'});
    }catch(error){
      return res.status(400).send({'message':'error'});
    }
  },
  //LOGIN
  async login (req,res){

  }
}


module.exports = Seller