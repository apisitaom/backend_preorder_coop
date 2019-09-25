const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const moment = require('moment');

async function getOrderDetail (req, res) {
    const id = req.params.id;
    let resp = [];
    const queryText = `SELECT 	op.orderid,op.createdate,													
	                            po.optionvalue,po.price,po.includingvat,												
	                            p.proname,																				
	                            po.price,od.amount,																		
	                            pays.statusname,																		
	                            pay.slip,pay.summary, 																	
	                            u.userid,u.firstname,u.lastname,u.addressUser,u.subdistrict,u.disstrict,u.province,u.zipcode													
                        FROM orderproduct op
                        FULL JOIN orderdetail od ON op.orderid = od.orderid
                        FULL JOIN productoption po ON od.proopid = po.proopid
                        FULL JOIN product p ON p.proid = po.proid
                        FULL JOIN member u ON u.userid = op.userid
                        FULL JOIN payment pay ON op.payid = pay.payid
                        FULL JOIN paymentstatus pays ON pay.paystatusid = pays.paystatusid
                        WHERE op.orderid IS NOT NULL and p.sellerid = $1`
    try {
        const result = await db.query(queryText,[id])
        for (let i = 0; i < (result.rows).length ;i++) {
            let value = {
                orderid : result.rows[0].orderid,
                orderdate : result.rows[0].createdate,
                cusname : result.rows[0].firstname + ' ' + result.rows[0].lastname,
                proname : result.rows[0].proname,
                option : result.rows[i].optionvalue,
                price : result.rows[i].price,
                amount : result.rows[i].amount,
                address : {
                    address : result.rows[i].addressuser,
                    subdistrict : result.rows[i].subdistrict,
                    district : result.rows[i].district,
                    province : result.rows[i].province,
                    zipcode : result.rows[i].zipcode
                }
            } 
            resp.push(value)             
        }
        return Responce.resSuccess(res, successMessage.success, resp);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}
async function add (req, res, next) {
    const {address, phonenumber, countdowntime, amount, proopid} = req.body;
    const active = true;
    // MEMBER
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);

    try {
        // proopid.map(async(element, index) => {
            db.query('BEGIN');
            const sqlorderproduct = `insert into orderproduct (active, userid) values ($1, $2) returning orderid`
            const valueorderproduct = [active, decode.data.id];
            const orderproduct = await db.query(sqlorderproduct, valueorderproduct);
            // orderproduct.rows.map(async(index) => {
            const sqlorderdetail = `insert into orderdetail (active, amount, address, phone, proopids, orderid) values ($1, $2, $3, $4, $5, $6)`
            const valueorderdetail = [active, amount, address, phonenumber, proopid, orderproduct.rows[0].orderid];
            await db.query(sqlorderdetail, valueorderdetail);
            // });
            db.query('COMMIT');
        // });
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        db.query('REVOKE');
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}
async function list (req, res, next) {
    // MEMBER
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sql = `select * 
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    where orderproduct.userid = $1`
    let responce = [];
    try {
        const { rows } = await db.query(sql, [decode.data.id]);
        const tranfrom = await Promise.all(rows.map(async(item) => {
            
        const productoption = await Productoption(item.proopids);
        return {
            orderdetailid: item.orderdetailid,
            amount: item.amount,
            address: item.address,
            orderid: item.orderid,
            phone: item.phone,
            result: productoption
            }
        }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}
async function Productoption (productoptionid) {
    const sql = `select productoption.proopid, productoption.price, productoption.includingvat,
    productoption.optionvalue, productoption.totalproduct,
    productoption.sku, 
    product.proid, product.proname, product.prodetail, product.photo, product.sellerid,
    product.timestart, product.timeend
    from productoption
    full join product on product.proid = productoption.proid
    where productoption.proopid = $1`
    return new Promise (async(resolve, reject) => {
         let data = await Promise.all(productoptionid.map(async(index) => {
            const {rows} = await db.query(sql, [index]);
            return rows
        }));
        resolve(data);
    });
}
module.exports = {
    getOrderDetail,
    add,
    list
}