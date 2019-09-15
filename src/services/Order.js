const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const moment = require('moment');

const Order = {
    async getOrderDetail (req, res) {
        const id = req.params.id
        let resp = []
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
            const response = {
                status : "200",
                message : "success",
                result : resp
            }
            return res.status(200).send(response)
        } catch (error) {
            const response = {
                status : "400",
                message : "error"
            }
            res.status(400).send(response)
            console.log(error)
        }
    }
}
module.exports = {Order}