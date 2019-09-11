const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')

function verifyToken(token) {
  const decode = jwt.verify(token, process.env.SECRET || 'Apisit0857646956');
  return decode;
}
function isValidEmail(email) {
  return /\S+@\S+\.\S+/.test(email);
}
function generateToken(datas) {
  const token = jwt.sign({
    data: datas
  },
    process.env.SECRET, { expiresIn: '24h' }
  );

  return token;
}
function comparePassword(hashPassword, password) {
  return bcrypt.compareSync(password, hashPassword);
}
function hashPassword(password) {
  return bcrypt.hashSync(password, bcrypt.genSaltSync(8))
}

exports.Helper = {
  verifyToken,
  isValidEmail,
  generateToken,
  comparePassword,
  hashPassword
}