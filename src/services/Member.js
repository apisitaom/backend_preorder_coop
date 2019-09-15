const db = require('../configdb/configDB');
const moment = require('moment');
const successMessage = require('../lib/successMessage');
const errorMessage = require('../lib/errorMessage');
const helper = require('../lib/Helper');
const Responce = require('../lib/Reposnce');

async function registerMember (req, res, next) {
    const { customerfirstname, customerlastname, sex, birthday, address, subdistrict, district, province, zipcode, phonenumber, email , picture, password} = req.body;
    if (!customerfirstname || !customerlastname || !sex || !email) {
        return Responce.resError(res, errorMessage.paramsNotMatch);
    }
    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const active = true;
    const hashPassword = helper.Helper.hashPassword(password);
    const sql = `INSERT INTO member (createdate, active, datemodify, firstname, lastname, gender, brithday, addressuser, subdistrict, disstrict, province, zipcode, photo, email, phone, passworduser) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)`

    const values = [date, active, date, customerfirstname, customerlastname, sex, birthday, address, subdistrict, district, province, zipcode, picture, email, phonenumber, hashPassword];
    
    try {
        const { rows } = await db.query(sql, values);
        return Responce.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

async function getProfileMember (req, res, next) {
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sql = `select firstname, lastname, gender, brithday, addressuser, subdistrict, disstrict, province, zipcode, photo, email, phone from member where userid = $1`
    const value = [decode.data.id];
    try {
        const { rows } = await db.query(sql, value);
        const tranfom = {
            customerfirstname: rows[0].firstname,
            customerlastname: rows[0].lastname,
            sex: rows[0].gender,
            birthday: rows[0].brithday,
            address: rows[0].addressuser,
            subdistrict: rows[0].subdistrict,
            district: rows[0].disstrict,
            province: rows[0].province,
            zipcode: rows[0].zipcode,
            phonenumber: rows[0].phone,
            email: rows[0].email,
            picture: rows[0].photo,       
        }
        return Responce.resSuccess(res, successMessage.success, tranfom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }   
}
async function updateMember (req, res, next) {
    console.log(req.body);
    const {customerfirstname, customerlastname, sex, birthday, address, subdistrict, district, province, zipcode, phonenumber, email} = req.body
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);

    const sql = `update member set firstname = $1, lastname = $2, gender = $3, brithday = $4, addressuser = $5,
    subdistrict = $6, disstrict = $7, province = $8, zipcode = $9, phone = $10, email = $11, photo = $12 where userid = $13`
    const value = [customerfirstname, customerlastname, sex, birthday, address, subdistrict, district, province, zipcode, phonenumber, email, req.files[0].filename,decode.data.id];
    try {
        await db.query(sql, value);
        return Responce.resSuccess(res, successMessage.upload);
    } catch (error){
        // throw error
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }

}

async function logInMember (req, res, next) {
    const { email, password } = req.body;  
    if (!email || !password) {
        return Responce.resError(res, errorMessage.paramsNotMatch);
    }
    const sql = 'SELECT * FROM member WHERE email = $1';

    try {
        const { rows } = await db.query(sql, [req.body.email]);
        if (!rows[0]) {
            return Responce.resError(res, errorMessage.saveError);
        }
        if (!helper.Helper.comparePassword(rows[0].passworduser, req.body.password)) {
            return Responce.resError(res, errorMessage.paramsNotMatch);
        } 
        const tranfrom = {
            id: rows[0].userid,
            firstname: rows[0].firstname,
            lastname: rows[0].lastname,
        }
        const mergedata = {
            firstname: rows[0].firstname,
            lastname: rows[0].lastname,
        }
        const token = helper.Helper.generateToken(tranfrom);
        return Responce.resSuccuessToken(res, successMessage.success, mergedata, token);
    }  catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

async function getPaymentCustomer (req, res, next) {
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);

    const sql = `select 
    product.photo, product.prodetail, product.proname,
    productoption.sku, productoption.price,productoption.optionvalue
    from orderproduct 
    full join member on member.userid = orderproduct.userid
    full join orderdetail on orderdetail.orderid = orderproduct.orderid
    full join productoption on productoption.proopid = orderdetail.proopid
    full join product on product.proid =  productoption.proid
    where member.userid = $1`
    const value = [decode.data.id]

    try {
        const { rows } = await db.query(sql, value  );
        return Responce.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        // throw error
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}
async function paymentCustomer (req, res, next) {
    const {total} = req.body
    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const paymentstatusid = 'd3025aa5-2444-4184-99cd-7e2b2bc744c5'; // ชำระเเล้ว
    const active = true;
    const sql = `insert into payment (active, datemodify, summary, slip, paystatusid) values  ($1, $2, $3, $4, $5)`
    const value = [active, date, total, req.files[0].filename, paymentstatusid];

    try {
        await db.query(sql, value);
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        // throw error
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}


module.exports = {
    registerMember,
    getProfileMember,
    logInMember,
    updateMember,
    getPaymentCustomer,
    paymentCustomer
}