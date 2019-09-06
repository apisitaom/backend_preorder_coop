const con = require('../configdb/config')
const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');

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
    try {
        const sql = ''
    } catch (error) {
        const { rows } = await db.query(sql);
    } finally {

    }
}

async function cartCustomer(req, res, next) {
    //Cart Customer

    const sql = 'select * from product full join productoption on product.proid = productoption.proid;'
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
}

