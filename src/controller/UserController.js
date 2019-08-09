const con = require('../config/config')
const Helper = require('./Helper')
const uuid4 = require('uuid4')
const moment = require('moment')

//BACKLIST FOR LOGUT JWT TOKEN 
const blacklist = require('jwt-blacklist');

const User = {
    //LOGIN
    async login(req,res){
     if(!req.body.email || !req.body.password){
         return res.status(400).send({'message':'Missing value1'})
     }
     if(!Helper.Helper.isValidEmail(req.body.email)){
         return res.status(400).send({'message':'Missing value2'});
     }
     const text = 'SELECT * FROM users WHERE email = $1';
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
    },
    //GET ALL USER
        async getUserData (req,res){
        const findAllQuery = 'select * from users';

        try{
        const { rows } = await con.pool.query(findAllQuery);
        console.log('Get Users-data');
            return res.status(200).send({rows});
        }catch(error){
            return res.status(400).send(error);
        }
    },
    //CREATE USER
    async createUser (req,res){
        if(!req.body.email || !req.body.password){
            return res.status(400).send({'message':'missing values 1'});
        }
        if(!Helper.Helper.isValidEmail(req.body.email)){
            return res.status(400).send({'message':'missing data 2 '});
    }
    const hasPassword = Helper.Helper.hashPassword(req.body.password);

    const createQuery = `INSERT INTO users(id,email,password,created_date,modified_date)
    VALUES($1, $2, $3, $4, $5)
      returning *`

    const value = [uuid4(),req.body.email,hasPassword,moment(Date.now()).format('YYYY-MM-DD HH:mm:ss'),moment(Date.now()).format('YYYY-MM-DD HH:mm:ss')];
    
    try{
        const { rows } = await con.pool.query(createQuery, value);
        console.log(req.body);
        const token = Helper.Helper.generateToken(rows[0].id);
        return res.status(200).send({ token });
    }catch(error){
        if (error.routine === '_bt_check_unique') {
            return res.status(400).send({ 'message': 'User with that EMAIL already exist' })
          }
        return res.status(400).send(error);
    }
    },
    //GET ONE
    async getUserOneData (req,res){
        const findAllQuery = 'select * from users where id = $1';
        try{
        const { rows } = await con.pool.query(findAllQuery,[req.params.id]);
        console.log('Get Users-data');
            return res.status(200).send({rows});
        }catch(error){
            return res.status(400).send(error);
        }
    },
    //LOGOUT
    async logOut (req,res){
        await  blacklist.revoke(req.headers.authorization)
        return res.json({success : true,'message':'login success'}).status(200)
    },

     //LOGOUT BY REFLESH TOKEN
     async logout(req,res){
        console.log(makeRefreshToken(200))
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


module.exports = {User}


