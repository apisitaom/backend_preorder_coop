// const Helper = require('../lib/Helper')
const moment = require('moment')
const db = require('../configdb/configDB');
const successMessage = require('../lib/successMessage');
const errorMessage = require('../lib/errorMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');

const Admin = {
    //LOGIN
    async login(req,res){
     if(!req.body.email || !req.body.password){
        //  return res.status(400).send({'message':'Missing value1'})
        return Responce.resError(res, errorMessage.saveError);
     }
     if(!helper.Helper.isValidEmail(req.body.email)){
       return Responce.resError(res, errorMessage.saveError);
        //  return res.status(400).send({'message':'Missing value2'});
     }
     const text = 'SELECT * FROM admin WHERE email = $1';
     try{
        const { rows } = await db.query(text,[req.body.email]);
        if(!rows[0]){
          return Responce.resError(res, errorMessage.saveError);
            // return res.status(400).send({'message':'Missing value3'});
        }
        if (!helper.Helper.comparePassword(rows[0].password, req.body.password)){
            // return res.status(400).send({'message':'Missing value4'});
            return Responce.resError(res, errorMessage.saveError);
        }
        const tranfrom = {
          id: rows[0].id
        }
        const token = helper.Helper.generateToken(tranfrom);
        // return res.status(200).send({token});
        return Responce.resSuccess(res, successMessage.success, token);
     }catch(error){
        return Responce.resError(res, errorMessage.saveError); 
        //  return res.status(400).send(error,{'message':'error'});
     }
    },
    //GET ALL USER
        async getUserData (req,res){
        const findAllQuery = 'select * from admin';

        try{
        const { rows } = await db.query(findAllQuery);
        console.log('Get Admin-data');
            return res.status(200).send({rows});
        }catch(error){
            return res.status(400).send(error);
        }
    },
    //CREATE USER
    async createAdmin(req, res) {
        if (!req.body.email || !req.body.password) {
          return res.status(400).send({'message': 'Some values are missing'});
        }
        if (!helper.Helper.isValidEmail(req.body.email)) {
          return res.status(400).send({ 'message': 'Please enter a valid email address' });
        }
        const hashPassword = helper.Helper.hashPassword(req.body.password);
    
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
          const { rows } = await db.query(createQuery, values);
          const token = helper.Helper.generateToken(rows[0].id);
          return res.status(201).send({ token });
        } catch(error) {
          if (error.routine === '_bt_check_unique') {
            return res.status(400).send({ 'message': 'User with that EMAIL already exist' })
          }
          return res.status(400).send(error);
        }
      },
    //GET ONE
    async getUserOneData (req,res){
        const findAllQuery = 'select * from admin where id = $1';
        try{
        const { rows } = await db.query(findAllQuery,[req.params.id]);
        console.log('Get Admin-data');
            return res.status(200).send({rows});
        }catch(error){
            return res.status(400).send(error);
        }
    },
    
     //RANDOM REFRESH TOKEN 
    async makeRefreshToken(length){
        var result = '';
        var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        var charactersLength = characters.length;

        for(let i=0;i<length;i++){
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
        }
        return result; 
    } 
}

module.exports = {Admin}


