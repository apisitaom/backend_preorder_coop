const con = require('../configdb/config')
const db = require('../configdb/configDB');
const Helper = require('../lib/Helper')
//MOMENT TIME
const moment = require('moment')
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Response = require('../lib/Reposnce');
const helper = require('../lib/Helper');

function responeSuccess(res, message, get) {
  res.send({
    code: 200,
    msg: message,
    data: get,
  });
}

function responeError(res, message, get) {
  res.send({
    code: 500,
    msg: message,
    data: get,
  });
}
const Seller = {
  async insert(req, res) {
    if (!req.body.email || !req.body.password) {
      return res.status(400).send({ 'message': 'missing values email or password' });
    }
    if (!Helper.Helper.isValidEmail(req.body.email)) {
      return res.status(400).send({ 'message': 'missing pattern email' });
    }
    const { shopname, address, subdistrict, district, province, zipcode, phone, email, password, taxid, bankname, accountname, accountnumber, promptpayname, promptpaynumber } = req.body
    const insertBank = 'INSERT INTO bank(createdate,active,datemodify,bankname,bankaccountname,banknumber) VALUES($1,$2,$3,$4,$5,$6) returning bankid'
    const insertPromptpay = 'INSERT INTO promptpay(createdate,active,datemodify,promptpayname,promptpaynumber) VALUES($1,$2,$3,$4,$5) returning promptpayid'
    const activeStatus = true
    const hashPassword = Helper.Helper.hashPassword(password);
    const today = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    const valuePromptpay = [today, activeStatus, today, promptpayname, promptpaynumber]
    const valueBank = [today, activeStatus, today, bankname, accountname, accountnumber]
    console.log('register seller')
    try {
      await con.pool.query('BEGIN')
      const rowBankNew = await con.pool.query(insertBank, valueBank)
      const rowPromptpayNew = await con.pool.query(insertPromptpay, valuePromptpay)
      const insertSeller = `INSERT INTO seller(active,datemodify,sellername,address,subdistrict,district,zipcode,province,phonenumber,email,sellerpassword,taxid,bankid,promptpayid) 
      VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14) returning sellerid`

      // const val = `{${req.files.map((item) => item.filename).join()}}`
      // const picture = []
      // picture.push(val)

      const value = [activeStatus, today, shopname, address, subdistrict, district, zipcode, province, phone, email, hashPassword, taxid, rowBankNew.rows[0].bankid, rowPromptpayNew.rows[0].promptpayid]
      await con.pool.query(insertSeller, value)
      await con.pool.query('COMMIT')
      return responeSuccess(res, successMessage.success);
    } catch (error) {
      if (error.routine === '_bt_check_unique') {
        return responeError(res, errorMessage.emailInvalid);
      }
      const response = {
        status: "400",
        message: "error"
      }
      return res.send(response)
    }
    finally {
      res.end()
      throw error
    }
  },
  //LOGIN
  async login(req, res) {
    if (!req.body.email || !req.body.password) {
      return res.status(400).send({ 'message': 'Missing value1' })
    }
    if (!Helper.Helper.isValidEmail(req.body.email)) {
      return res.status(400).send({ 'message': 'Missing value2' });
    }
    console.log('login seller')
    const text = 'SELECT * FROM seller WHERE email = $1';
    try {
      const { rows } = await con.pool.query(text, [req.body.email]);
      if (!rows[0]) {
        return res.status(400).send({ 'message': 'Missing value3' });
      }
      if (!Helper.Helper.comparePassword(rows[0].sellerpassword, req.body.password)) {
        return res.status(400).send({ 'message': 'Missing value4' });
      }
      const token = Helper.Helper.generateToken(rows[0].sellerid);
      // console.log(rows);
      // console.log(rows[0]);
      const tranfrom = {
        sellerid: rows[0].sellerid
      }
      return Response.resSuccuessToken(res, successMessage.success, tranfrom, token);
      // return res.status(200).send(response);

    } catch (error) {
      const response = {
        status: "400",
        message: "error"
      }
      return res.status(400).send(response, { 'message': 'error' });
    }
  },
  async getall(req, res) {
    const sql = 'select * from seller'

    try {
      const { rows } = await con.pool.query(sql)
      return res.status(200).send(rows)
    } catch (error) {
      const response = {
        status: "400",
        message: "error"
      }
      return res.status(400).send(response)
    }
  },
  //SHOPINFO-SALER
  async shopinfo(req, res) {
    const sql = `select seller.sellername,seller.address,seller.subdistrict,seller.district,seller.zipcode
                ,seller.province,seller.phonenumber,seller.email,seller.photo,bank.bankname,bank.bankaccountname,bank.banknumber,
                promptpay.promptpayname,promptpay.promptpaynumber from seller inner join bank on seller.bankid = bank.bankid 
                inner join promptpay on seller.promptpayid = promptpay.promptpayid where seller.sellerid = $1`
    try {
      const { rows } = await con.pool.query(sql, [req.params.id])
      console.log('get shopinfo-saler')
      const response = {
        shopname: rows[0].sellername,
        address: rows[0].address,
        subdistrict: rows[0].subdistrict,
        dustrict: rows[0].district,
        province: rows[0].province,
        zipcode: rows[0].zipcode,
        phone: rows[0].phonenumber,
        email: rows[0].email,
        picture: rows[0].photo,
        bankname: rows[0].bankname,
        accountname: rows[0].bankaccountname,
        accountnumber: rows[0].banknumber,
        promptpayname: rows[0].banknumber,
        promptpayname: rows[0].promptpayname,
        promptpaynumber: rows[0].promptpaynumber,
      }
      return res.status(200).send(response)
    } catch (error) {
      return res.status(400).send({ 'message': 'error' })
    }
  },
  async orderlist_saler(req, res) {

    const sql = `select member.firstname, member.lastname,orderproduct.createdate from orderproduct full join orderproduct on member.userid = orderproduct.userid; `

    console.log('orderlist-seller')

    try {

    } catch (error) {

    } finally {
      throw error
    }
  },

  // customer-profile
  async updateSeller(req, res, next) {
    const { shopname, address, subdistrict, district, province, zipcode, phone, email, password, bankname, accountname, accountnumber, promptpayname, promptpaynumber, } = req.body
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);

    const hashPassword = helper.Helper.hashPassword(password);

    // PICTURE
    const val = `{${req.files.map((item) => item.filename).join()}}`
    const picture = []
    picture.push(val)

    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss')

    const sql = `select * from seller where sellerid = $1`
    const values = [decode.data]
    const { rows } = await db.query(sql, values);

    // SELLER
    const sqlSeller = `update seller set sellername = $1, address = $2, subdistrict = $3, district = $4, zipcode = $5, province = $6, phonenumber = $7, email = $8, sellerpassword = $9 , photo = $10, datemodify = $11 where sellerid = $12 `
    const valueSeller = [shopname, address, subdistrict, district, zipcode, province, phone, email, hashPassword, picture, date, decode.data]
    // BANK
    const sqlBank = `update bank set datemodify = $1, bankname = $2, bankaccountname = $3, banknumber = $4 where bankid = $5`
    const valuebank = [date, bankname, accountname, accountnumber, rows[0].bankid]
    // PROMPTPAY
    const sqlPromptpay = `update promptpay set datemodify = $1, promptpayname = $2, promptpaynumber = $3 where promptpayid = $4`
    const valuePrompay = [date, promptpayname, promptpaynumber, rows[0].promptpayid]

    try {
      await db.query(sqlSeller, valueSeller);

      await db.query(sqlBank, valuebank);

      await db.query(sqlPromptpay, valuePrompay);

      return Response.resSuccess(res, successMessage.upload);

    } catch (error) {
      return Response.resError(res, errorMessage.saveError);
    } finally {
      res.end();
    }
  }
}

module.exports = Seller
