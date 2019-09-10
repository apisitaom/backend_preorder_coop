const con = require('../configdb/config')
const db = require('../configdb/configDB');

//Message
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
//Responce
const responce = require('../lib/Reposnce');
const moment = require('moment');

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

const Product = {
    async getPopup(req, res) {

        const getPopup = `select product.photo,product.proname,productoption.price,productoption.optionvalue
        from product inner join productoption on product.proid = productoption.proid where product.proid = $1`;
        try {
            const { rows } = await con.pool.query(getPopup, [req.params.id]);
            console.log('get popup data')
            return res.status(200).send({ 'message': 'get popup success', rows });
        } catch (error) {
            return res.status(400).send({ 'message': 'error' });
        }
    },
    async getMaxMin(req, res) {
        try {
            const selectMin = `SELECT pro.proid,pro.proname,proop.price 
                                    FROM product pro 
                                    FULL JOIN productoption proop 
                                    ON pro.proid = proop.proid 
                                WHERE price = (
                                    SELECT DISTINCT 
                                    MIN (price) 
                                    FROM productoption 
                                    WHERE proid  = $1)`
            const selectMax = `SELECT pro.proid,pro.proname,proop.price 
                                    FROM product pro 
                                    FULL JOIN productoption proop 
                                    ON pro.proid = proop.proid 
                                WHERE price = (
                                    SELECT DISTINCT 
                                    MAX (price) 
                                    FROM productoption 
                                    WHERE proid  = $1)`
            const selectProduct = 'select proid,proname from product'
            const result = await con.pool.query(selectProduct)
            let sumValue = []
            let price, allValue
            for (let i = 0; i < (result.rows).length; i++) {
                const id = result.rows[i].proid
                const queryMax = await con.pool.query(selectMax, [id])
                const queryMin = await con.pool.query(selectMin, [id])
                const max = queryMax.rows[i].price
                const min = queryMin.rows[i].price
                const proName = result.rows[i].proname
                price = min + ' - ' + max
                allValue = {
                    order: i + 1,
                    proid: id,
                    proname: proName,
                    price: price
                }
                sumValue.push(allValue)
            }
            return res.status(200).send(sumValue)
        } catch (error) {
            console.log(error)
        }
    }
}

async function homepageCustomer(req, res, next) {
    //Homepage-cutomer
    const sql = `select product.proname, product.photo, eventproduct.timestart,
    eventproduct.timeend, eventproduct.countdowntime, 
    productoption.optionvalue,  productoption.price, seller.sellername from productoption 
    full join product on product.proid = productoption.proid 
    full join eventdetail on eventdetail.eventid = productoption.proid
    full join eventproduct on eventproduct.eventid = eventdetail.eventid
    full join seller on seller.sellerid = product.sellerid;
    `
    try {
        const { rows } = await db.query(sql);
        return responce.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        return responce.resError(res, errorMessage.saveError, );
    } finally {
        res.end();
    }
}

async function insertProductHomepage (req, res, next) {
    
    const { productname, amount, datepre  ,sellerid} = req.body

    const active = true;
    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const isNull = "-";
    const uuId = '99e650ff-683d-42ca-a05b-3528505f7e60';
    const  sqlProduct = `insert into product ( active, proname, sellerid) values ($1, $2, $3) returning proid`
    const valuesProduct = [ active, productname, sellerid ];
    
    // ORDER PRODUCT
    // const sqlOrderProduct = `insert into orderproduct ( active) values ($1) returning orderid`
    // const valuesOrderProduct = [  active ];

    // MEMBER 
    const sqlMember = ``
    const valueMember = [];
    
    const sqlOrderDetail = `insert into orderdetail ( active, amount, proid) values ($1, $2, $3)`

    try {
        await db.query('BEGIN');
        
        const  product  = await db.query(sqlProduct, valuesProduct);

        const values = [ active, amount, product.rows[0].proid];
        const orderdetail = await db.query(sqlOrderDetail, values);

        console.log('==============>', product.rows[0].proid);
    
        await db.query('COMMIT');

        return responce.resSuccess(res, successMessage.success);
    } catch (error) {
        throw error
        // await db.query('REVOKE');
        // return responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

async function cartCustomer(req, res, next) {
    //Cart Customer

    const sql = 'select * from product full join productoption on product.proid = productoption.proid'
    //Member Table
    const psql = 'select * from member'
    try {
        const { rows } = await db.query(sql);
        const { trans } = await db.query(psql);
        console.log(rows.length)
        console.log(trans);
        return responeSuccess(res, successMessage.success, rows);
    } catch (error) {
        return responeError(res, errorMessage.saveError)
    } finally {
        throw error
    }

}

module.exports = {
    Product,
    cartCustomer,
    homepageCustomer,
    insertProductHomepage,
}

