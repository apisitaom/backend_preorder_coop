const con = require('../configdb/config')
const Helper = require('../lib/Helper')
const moment = require('moment')
const blacklist = require('express-jwt-blacklist-updated');

module.exports = { 
  updatePaymentStatus, 
  updateSellerStatus,
  login, 
  getUserData, 
  createAdmin, 
  getUserOneData, 
  sellers,
  orders
}

function responceSuccess (res, message, get){
  res.send({
      code: 200,
      msg: message,
      data: get
  });
}
function responceError (res, message, get){
  res.send({
      code: 500,
      msg: message
  });
}

function responceErrReq (res, message, get){
  res.send({
      code: 400,
      msg: message,
      data: get
  });
}
async function login (req,res){
  if(!req.body.email || !req.body.password){
      return res.status(400).send({'message':'Missing value1'})
  }
  if(!Helper.Helper.isValidEmail(req.body.email)){
      return res.status(400).send({'message':'Missing value2'});
  }
  const text = 'SELECT * FROM admin WHERE email = $1';
  try{
    const { rows } = await con.pool.query(text,[req.body.email]);
    if(!rows[0]){
        return res.status(400).send({'message':'Missing value3'});
    }
    if (!Helper.Helper.comparePassword(rows[0].password, req.body.password)){
        return res.status(400).send({'message':'Missing value4'});
    }
    const token = Helper.Helper.generateToken(rows[0].id);
    return res.status(200).send({token});
  }catch(error){
      return res.status(400).send(error,{'message':'error'});
  }
}
async function getUserData (req,res){
  const findAllQuery = 'select * from admin';
  try{
  const { rows } = await con.pool.query(findAllQuery);
  console.log('Get Admin-data');
      return res.status(200).send({rows});
  }catch(error){
      return res.status(400).send(error);
  }
}
async function createAdmin(req, res){
    if (!req.body.email || !req.body.password) {
      return res.status(400).send({'message': 'Some values are missing'});
    }
    if (!Helper.Helper.isValidEmail(req.body.email)) {
      return res.status(400).send({ 'message': 'Please enter a valid email address' });
    }
    const hashPassword = Helper.Helper.hashPassword(req.body.password);

    const createQuery = `INSERT INTO
      admin( email, password, created_date, modified_date)
      VALUES( $1, $2, $3, $4)
      returning *`;
    const values = [
      req.body.email,
      hashPassword,
      moment(new Date()),
      moment(new Date())
    ];

    try {
      const { rows } = await con.pool.query(createQuery, values);
      const token = Helper.Helper.generateToken(rows[0].id);
      return res.status(201).send({ token });
    } catch(error) {
      if (error.routine === '_bt_check_unique') {
        return res.status(400).send({ 'message': 'User with that EMAIL already exist' })
      }
      return res.status(400).send(error);
    }
  }
async function getUserOneData(req,res){
    const findAllQuery = 'select * from admin where id = $1';
    try{
    const { rows } = await con.pool.query(findAllQuery,[req.params.id]);
    console.log('Get Admin-data');
        return res.status(200).send({rows});
    }catch(error){
        return res.status(400).send(error);
    }
}
async function makeRefreshToken(length){
    var result = '';
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;

    for(let i=0;i<length;i++){
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result; 
}
async function sellers(req, res){
  let value =''
  let sql = `
    SELECT 
      seller.sellerid, seller.createdate, seller.active, seller.sellername, seller.address, seller.subdistrict, seller.district, seller.zipcode, seller.phonenumber,seller.email, seller.taxid, seller.photo, 
      promptpay.promptpayname, promptpay.promptpaynumber,
      bank.bankname, bank.bankaccountname, bank.banknumber
    FROM seller
    FULL JOIN promptpay
      ON	seller.promptpayid = promptpay.promptpayid
    FULL JOIN bank
      ON	seller.bankid = bank.bankid
  `
  try {
    if(req.params.id){
      sql += ` WHERE sellerid = $1`
      value = await con.pool.query(sql,[req.params.id]);
    }else{
      value = await con.pool.query(sql);
    }
    const data = {
      seller: value.rows[0].sellerid,
      shopname: value.rows[0].sellername,
      thimestamp: value.rows[0].createdate,
      email: value.rows[0].email,
      active: value.rows[0].active,
      address: value.rows[0].address,
      subdistrict: value.rows[0].subdistrict,
      district: value.rows[0].district,
      province: value.rows[0].province,
      zipcode: value.rows[0].zipcode,
      phone: value.rows[0].phonenumber,
      taxid: value.rows[0].taxid,
      bankname: value.rows[0].bankname,
      accountname: value.rows[0].bankaccountname,
      accountnumber: value.rows[0].banknumber,
      promptpayname: value.rows[0].promptpayname,
      promptpaynumber: value.rows[0].promptpaynumber
    }
    return responceSuccess(res, 'Success', data)
  } catch (error) {
    return responceError(res, 'Error in database', error)
  }
}
async function updateSellerStatus(req, res){
  const sql = `
    UPDATE seller SET active = $1 WHERE sellerid = $2
  `
  const sqlValue = [req.body.active, req.params.id]
  try {
    con.pool.query(sql, sqlValue)
    return responceSuccess(res, 'Update Success')
  } catch (error) {
    console.log(error)
    return responceError(res, 'Error in database', error)
  }
}

async function orders(req, res){
  let sql = `
  SELECT 
    orderproduct.orderid, mem.userid as customerid, mem.firstname, mem.lastname,
    paymentstatus.statusname as paymentstatus, payment.summary as totalprice, product.proid, product.proname,
    productoption.optionvalue, productoption.sku, orderdetail.amount, productoption.includingvat, productoption.price, orderdetail.total,
    payment.payid, payment.datemodify, payment.slip,
    seller.sellerid, seller.sellername, 
    bank.bankname, bank.bankaccountname, bank.banknumber,
    promptpay.promptpayname, promptpay.promptpaynumber
  FROM orderproduct
  FULL JOIN member mem
    ON orderproduct.userid = mem.userid
  FULL JOIN payment
    ON orderproduct.payid = payment.payid
  FULL JOIN orderdetail
    ON orderproduct.orderid = orderdetail.orderid
  FULL JOIN productoption
    ON orderdetail.proopid = productoption.proopid
  FULL JOIN product
    ON productoption.proid = product.proid
  FULL JOIN paymentstatus
    ON payment.paystatusid = paymentstatus.paystatusid
  FULL JOIN seller
    ON product.sellerid = seller.sellerid
  FULL JOIN bank
    ON seller.bankid = bank.bankid
  FULL JOIN promptpay
    ON seller.promptpayid = promptpay.promptpayid
  WHERE orderproduct.userid != null
  `
  const sqlGetOneOrder = `
    and orderproduct.userid = $1
  `
  let respValue
  try {
    if(req.params.id){
      sql += " " + sqlGetOneOrder
      console.log(sql)
      respValue = await con.pool.query(sql, [req.params.id])
    }else{
      respValue = await con.pool.query(sql)
    }
    if(respValue.rows[0] === undefined){
      return responceSuccess(res, 'No data')
    }else{
      const data = {
        orderid : respValue.rows[0].orderid,
        customerid : respValue.rows[0].customerid,
        customername: respValue.rows[0].firstname + " " + respValue.rows[0].lastname,
        paymentstatus: respValue.rows[0].paymentstatus,
        totalprice: respValue.rows[0].totalprice,
        productid: respValue.rows[0].proid,
        proname: respValue.rows[0].proname,
        option: [{
          sku: respValue.rows[0].sku,
          buyamount: respValue.rows[0].amount,
          vat: respValue.rows[0].includingvat,
          price: respValue.rows[0].price,
          total: respValue.rows[0].total,
          optionvalue: respValue.rows[0].optionvalue
        }],
        payid: respValue.rows[0].payid,
        paydate: respValue.rows[0].datemodify,
        slip: respValue.rows[0].slip,
        sellerid: respValue.rows[0].sellerid,
        shopname: respValue.rows[0].sellername,
        bankname: respValue.rows[0].bankname,
        bankaccountname: respValue.rows[0].bankaccountname,
        banknumber: respValue.rows[0].bankaccountnumber,
        promptpayname: respValue.rows[0].promptpayname,
        promptpaynumber: respValue.rows[0].promptpaynumber
      }
      return responceSuccess(res, 'Success', data)
    }
  } catch (error) {
    console.log(error)
    return responceError(res, 'Error in database', error)
  }
}

async function updatePaymentStatus(req, res){
  const sql = `
    UPDATE payment SET paystatusid = $1
    WHERE payid = $2
  `
  const value = [ req.body.payid, req.params.id ]
  try {
    const a = await con.pool.query(sql, value)
    console.log(a)
    return responceSuccess(res, 'Update Success')
  } catch (error) {
    console.log(error)
    return responceError(res, 'Error in database', error)
  }
}

