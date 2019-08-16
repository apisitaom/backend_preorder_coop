const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const dotenv = require('dotenv')
dotenv.config();

console.log(dotenv.parsed)

const Helper = {
    hashPassword(password){
        return bcrypt.hashSync(password, bcrypt.genSaltSync(8))
    },
    comparePassword(hashPassword, password) {
        return bcrypt.compareSync(password, hashPassword);
      },
    isValidEmail(email){
        return /\S+@\S+\.\S+/.test(email);
    },
    generateToken(id) {
        const token = jwt.sign({
          userId: id
        },
        process.env.SECRET || 'Apisit0857646956' , { expiresIn: '1d' }
        );
    
        return token;
      }
    
      
    }

exports.Helper = Helper