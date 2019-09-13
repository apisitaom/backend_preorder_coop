const jwt = require('jsonwebtoken')
const db = require('../configdb/configDB');
const helper = require('../lib/Helper');
const Responce = require('../lib/Reposnce');
const successMessage = require('../lib/successMessage');
const errorMessage = require('../lib/errorMessage');

async function userVerifyToken(req, res, next) {
  const { headers } = req;
  const subtoken = headers.authorization.split(' ');
  const token = subtoken[1];
  const decode = helper.Helper.verifyToken(token);

  if (!token) {
    return Responce.resError(res, errorMessage.noToken);
  }
  try {
    const text = 'SELECT * FROM member WHERE userid = $1';
    const { rows } = await db.query(text, [decode.data.id]);
    if (!rows[0]) {
      return Responce.resError(res, errorMessage.tokeninvalid);
    }
    req.user = { id: decode.data.id };
    next();
  } catch (error) {
    return Responce.resError(res, errorMessage.saveError);
  } 
}
//เปลี่ยน decode ก่อน
async function adminVerifyToken(req, res, next){
  const { headers } = req;
  const subtoken = headers.authorization.split(' ');
  const token = subtoken[1];
  const decode = helper.Helper.verifyToken(token);
    if (!token) {
    return Responce.resError(res, errorMessage.noToken);
  }
  try {
    const text = 'SELECT * FROM admin WHERE id = $1';
    //change here
    const { rows } = await db.query(text, [decode.data.id]);
    if (!rows[0]) {
      return Responce.resError(res, errorMessage.tokeninvalid);
    }
    //change here
    req.user = { id: decode.data.id };
    next();
  } catch (error) {
    return Responce.resError(res, errorMessage.saveError);
  }

}
//เปลี่ยน decode ก่อน 
async function sellerVerifyToken(req, res, next){
const { headers } = req;
  const subtoken = headers.authorization.split(' ');
  const token = subtoken[1];
  const decode = helper.Helper.verifyToken(token);
    if (!token) {
    return Responce.resError(res, errorMessage.noToken);
  }
  try {
    const text = 'SELECT * FROM seller WHERE sellerid = $1';
    //change here
    const { rows } = await db.query(text, [decode.data.id]);
    if (!rows[0]) {
      return Responce.resError(res, errorMessage.tokeninvalid);
    }
    //change here
    req.user = { id: decode.data.id };
    next();
  } catch (error) {
    return Responce.resError(res, errorMessage.saveError);
  }
}


module.exports = {
  userVerifyToken,
  adminVerifyToken,
  sellerVerifyToken
}

