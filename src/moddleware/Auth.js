const jwt = require ('jsonwebtoken')
const con = require('../config/config')

const Auth = {
  //USER VERIFY TOKEN
    async verifyToken(req, res, next) {
        const token = req.headers['x-access-token'];
        if(!token) {
          return res.status(400).send({ 'message': 'Token is not provided' });
        }
        try {
          const decoded = await jwt.verify(token, process.env.SECRET || 'Apisit0857646956');
          const text = 'SELECT * FROM users WHERE id = $1';
          const { rows } = await con.pool.query(text, [decoded.userid]);
          if(!rows[0]) {
            return res.status(400).send({ 'message': 'The token you provided is invalid' });
          }
          req.user = { id: decoded.userid };
          next();
        } catch(error) {
          return res.status(400).send(error);
        }
      }
}

exports.Auth = Auth

