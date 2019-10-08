const db = require('../configdb/configDB');
const moment = require('moment')
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Response = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const productoptions = require('./productoptions'); 

async function insert(req, res) {
  if (!req.body.email || !req.body.password) {
    return Response.resError(res, errorMessage.paramsNotMatch);
  }
  if (!helper.Helper.isValidEmail(req.body.email)) {
    return Response.resError(res, errorMessage.paramsNotMatch);
  }
  const { shopname, address, subdistrict, district, province, zipcode, phone, email, password, taxid, bankname, accountname, accountnumber, promptpayname, promptpaynumber,picture } = req.body
  const insertBank = 'INSERT INTO bank(createdate,active,datemodify,bankname,bankaccountname,banknumber) VALUES($1,$2,$3,$4,$5,$6) returning bankid'
  const insertPromptpay = 'INSERT INTO promptpay(createdate,active,datemodify,promptpayname,promptpaynumber) VALUES($1,$2,$3,$4,$5) returning promptpayid'
  const activeStatus = true;
  const hashPassword = helper.Helper.hashPassword(password);
  const today = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss')
  const valuePromptpay = [today, activeStatus, today, promptpayname, promptpaynumber]
  const valueBank = [today, activeStatus, today, bankname, accountname, accountnumber]
  try {
    if (!req.files[0] || !req.files ||req.files === null || req.files === [] || req.files[0] === undefined) {
      const rowBankNew = await db.query(insertBank, valueBank);
      const rowPromptpayNew = await db.query(insertPromptpay, valuePromptpay)
      const insertSeller = `INSERT INTO seller(active,datemodify,sellername,address,subdistrict,district,zipcode,province,phonenumber,email,sellerpassword,taxid,bankid,promptpayid) 
      VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14) returning sellerid`
      const value = [activeStatus, today, shopname, address, subdistrict, district, zipcode, province, phone, email, hashPassword, taxid, rowBankNew.rows[0].bankid, rowPromptpayNew.rows[0].promptpayid]
      await db.query(insertSeller, value);
    } else {
      const rowBankNew = await db.query(insertBank, valueBank);
      const rowPromptpayNew = await db.query(insertPromptpay, valuePromptpay)
      const insertSeller = `INSERT INTO seller(active,datemodify,sellername,address,subdistrict,district,zipcode,province,phonenumber,email,sellerpassword,taxid,bankid,promptpayid, photo) 
      VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15) returning sellerid`
      const value = [activeStatus, today, shopname, address, subdistrict, district, zipcode, province, phone, email, hashPassword, taxid, rowBankNew.rows[0].bankid, rowPromptpayNew.rows[0].promptpayid, req.files[0].filename]
      await db.query(insertSeller, value);
    }
      return Response.resSuccess(res, successMessage.success);
  } catch (error) {
    if (error.routine === '_bt_check_unique') {
      return Response.resError(res, errorMessage.emailInvalid);
    }
    return Response.resError(res, errorMessage.saveError);
  } finally {
    res.end();
  }
}
async function login(req, res) {
  if (!req.body.email || !req.body.password) {
    return Response.resError(res, errorMessage.saveError);
  }
  if (!helper.Helper.isValidEmail(req.body.email)) {
    return Response.resError(res, errorMessage.saveError);
  }
  const text = 'SELECT * FROM seller WHERE email = $1';
  try {
    const { rows } = await db.query(text, [req.body.email]);
    if (!rows[0]) {
      return Response.resError(res, errorMessage.saveError);
    }
    if (!helper.Helper.comparePassword(rows[0].sellerpassword, req.body.password)) {
      return Response.resError(res, errorMessage.saveError);
    }
    const mergedata = {
      sellerid: rows[0].sellerid,
      shopname: rows[0].sellername,
    }
    const tranfrom = {
      id: rows[0].sellerid
    }
    const token = helper.Helper.generateToken(tranfrom);
    return Response.resSuccuessToken(res, successMessage.success, mergedata, token);
  } catch (error) {
    return Response.resError(res, errorMessage.saveError);
  }
}
async function lists(req, res) {
  const sql = `select 
  seller.sellerid,seller.sellername,seller.address,seller.subdistrict,seller.district,seller.zipcode,
  seller.province,seller.phonenumber,seller.email,seller.photo,
  bank.bankname,bank.bankaccountname,bank.banknumber,
  promptpay.promptpayname,promptpay.promptpaynumber 
  from seller 
  inner join bank on seller.bankid = bank.bankid 
  inner join promptpay on seller.promptpayid = promptpay.promptpayid 
  where seller.sellerid = $1`
  try {
    const { rows } = await db.query(sql, [req.params.id]);
    const tranfrom = {
      sellerid: rows[0].sellerid,
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
    return Response.resSuccess(res, successMessage.success, tranfrom);
  } catch (error) {
    return Response.resError(res, errorMessage.saveError);
  }
}
async function edit(req, res, next) {
  const { shopname, address, subdistrict, district, province, zipcode, phone, email, bankname, accountname, accountnumber, promptpayname, promptpaynumber, } = req.body
  const { headers } = req;
  const subtoken = headers.authorization.split(' ');
  const token = subtoken[1];
  const decode = helper.Helper.verifyToken(token);
  const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss')
  const sql = `select * from seller where sellerid = $1`
  const values = [decode.data.id]
  const { rows } = await db.query(sql, values);
  const sqlBank = `update bank set datemodify = $1, bankname = $2, bankaccountname = $3, banknumber = $4 where bankid = $5`
  const valuebank = [date, bankname, accountname, accountnumber, rows[0].bankid]
  const sqlPromptpay = `update promptpay set datemodify = $1, promptpayname = $2, promptpaynumber = $3 where promptpayid = $4`
  const valuePrompay = [date, promptpayname, promptpaynumber, rows[0].promptpayid]
  try {
    if (!req.files[0] || req.files === null || req.files === [] || req.files[0] === undefined) {
      const sqlSeller = `update seller set sellername = $1, address = $2, subdistrict = $3, district = $4, zipcode = $5, province = $6, phonenumber = $7, email = $8, datemodify = $9 where sellerid = $10 `
      const valueSeller = [shopname, address, subdistrict, district, zipcode, province, phone, email, date, decode.data.id]    
      await db.query(sqlSeller, valueSeller);
    } else {
      const sqlSeller = `update seller set sellername = $1, address = $2, subdistrict = $3, district = $4, zipcode = $5, province = $6, phonenumber = $7, email = $8, photo = $9, datemodify = $10 where sellerid = $11 `
      const valueSeller = [shopname, address, subdistrict, district, zipcode, province, phone, email, req.files[0].filename, date, decode.data.id] 
      await db.query(sqlSeller, valueSeller);
    }
    await db.query(sqlBank, valuebank);
    await db.query(sqlPromptpay, valuePrompay);
    return Response.resSuccess(res, successMessage.upload);
  } catch (error) {
    return Response.resError(res, errorMessage.saveError);
  } finally {
    res.end();
  }
}
async function all(req, res) {
  const sql = `select 
  seller.active,seller.taxid, seller.createdate, seller.sellerid,seller.sellername,seller.address,seller.subdistrict,seller.district,seller.zipcode,
  seller.province,seller.phonenumber,seller.email,seller.photo,
  bank.bankname,bank.bankaccountname,bank.banknumber,
  promptpay.promptpayname,promptpay.promptpaynumber 
  from seller 
  inner join bank on seller.bankid = bank.bankid 
  inner join promptpay on seller.promptpayid = promptpay.promptpayid`
  try {
    const { rows } = await db.query(sql);
    return Response.resSuccess(res, successMessage.success, rows);
  } catch (error) {
    return Response.resError(res, errorMessage.saveError);
  }
}
async function Role (req, res) {
  const { active, sellerid } = req.body;
  const sql = `update seller set active = $1 where sellerid = $2`;
  const value = [active, sellerid];
  try {
    await db.query(sql, value);
    return Response.resSuccess(res, successMessage.success);
  } catch (error) {
    return Response.resError(res, errorMessage.saveError);
  }
}
async function buy (req, res, next) {
  const { headers } = req;
  const subtoken = headers.authorization.split(' ');
  const token = subtoken[1];
  const decode = helper.Helper.verifyToken(token);
  const sql = `select * 
  from orderdetail 
  full join orderproduct on orderproduct.orderid = orderdetail.orderid
  full join payment on payment.payid = orderproduct.payid
  full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
  full join shipping on shipping.shipid = orderproduct.shipid
  full join shippingstatus on shippingstatus.shipstatusid = shipping.shipstatusid
  full join member on member.userid = orderproduct.userid 
  `
  try {
      const { rows } = await db.query(sql);
      const tranfrom = await Promise.all(rows.map(async(item) => {
        if (item.proopids != null) {
        const productoption = await productoptions.ProductoptionSeller(item.proopids, item.amounts, decode.data.id);
        let sum = 0;
        let datas = []
        productoption.map(async(element, index) => {
            sum += element.totalprice;
            if (element !== null || element !== undefined) {
              datas.push(element);
            }
        })
        
        if (productoption[0] != undefined) {
          let responce = {
            fullname: item.firstname +' '+ item.lastname,
            createdate: moment(item.createdate,).format('YYYY-MM-DD HH:mm:ss'),
            orderid: item.orderid,
            orderdetailid: item.orderdetailid,
            amounts: item.amounts,
            address: item.address,
            disstrict: item.disstrict,
            province: item.province,
            zipcode: item.zipcode,
            orderid: item.orderid,
            phone: item.phone,
            statusname: item.statusname,
            shippingstatusname: item.shippingstatusname,
            total: sum,
            result: datas,
          }
          return responce != undefined && responce 
          }
        }
      }));
      let data = []
      tranfrom.map(async(item) => {
        if(item != undefined){
          data.push(item);
        }
      })
      
      return Response.resSuccess(res, successMessage.success, data);
  } catch (error) {
      return Response.resError(res, errorMessage.saveError);
  }
}
async function buyid (req, res, next) {
  const { headers } = req;
  const subtoken = headers.authorization.split(' ');
  const token = subtoken[1];
  const decode = helper.Helper.verifyToken(token);
  const sql = `select * 
  from orderdetail 
  full join orderproduct on orderproduct.orderid = orderdetail.orderid
  full join payment on payment.payid = orderproduct.payid
  full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
  full join shipping on shipping.shipid = orderproduct.shipid
  full join shippingstatus on shippingstatus.shipstatusid = shipping.shipstatusid
  full join member on member.userid = orderproduct.userid
  where orderproduct.orderid = $1 
  `
  try {
      const { rows } = await db.query(sql, [req.params.id]);
      const tranfrom = await Promise.all(rows.map(async(item) => {
        if (item.proopids != null) {
        const productoption = await productoptions.ProductoptionSeller(item.proopids, item.amounts, decode.data.id);
        let sum = 0;
        let datas = []
        productoption.map(async(element, index) => {
          sum += element.totalprice;
          if (element !== null || element !== undefined) {
            datas.push(element);
          }
      })
        if (productoption[0] != undefined) {
          let responce = {
            fullname: item.firstname +' '+ item.lastname,
            createdate: moment(item.createdate,).format('YYYY-MM-DD HH:mm:ss'),
            orderid: item.orderid,
            orderdetailid: item.orderdetailid,
            amounts: item.amounts,
            address: item.address,
            disstrict: item.disstrict,
            province: item.province,
            zipcode: item.zipcode,
            orderid: item.orderid,
            phone: item.phone,
            statusname: item.statusname,
            shippingstatusname: item.shippingstatusname,
            total: sum,
            result: datas,
          }
          return responce != undefined && responce 
          }
        }
      }));
      let data = []
      tranfrom.map(async(item) => {
        if(item != undefined){
          data.push(item);
        }
      })
      
      return Response.resSuccess(res, successMessage.success, data);
  } catch (error) {
      return Response.resError(res, errorMessage.saveError);
  }
}
async function shippingadd (req, res, next) {
  const { shipid, shiptrackno } = req.body;
  const sql = ``
  const value = []
  try {
    return Response.resSuccess(res, successMessage.success);    
  } catch (error) {
    return Response.resError(res, errorMessage.saveError);
  }
}
module.exports = {
  insert,
  login,
  lists,
  edit,
  all,
  Role,
  buy,
  buyid
}
