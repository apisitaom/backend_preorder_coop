const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Response = require('../lib/Reposnce');

module.exports = {
    sales,
    totalAmount,
    totalCustomer,
    topTenProducts,
    graph,
    users,
    productSale
}
async function productSale (req, res) {
    let date = ''
    if(req.body.value === 'month'){
        date = 'extract(month from receipt.createdate)'
    }else if(req.body.value === 'year'){
        date = 'extract(year from receipt.createdate)'
    }else{
        date = 'date(receipt.createdate)'
    }
    const sql = `
    select ${date}, receipt_detail.proid, receipt_detail.product_name, sum(receipt_detail.grand_price), sum(receipt_detail.amount)
    from receipt_detail
    inner join receipt
        on receipt_detail.receipt_id = receipt.receipt_id
    where proid = $1
    group by ${date}, receipt_detail.proid, receipt_detail.product_name
    `
    const value = [req.params.id]
    try {
        const { rows } = await db.query(sql, value)
        return Response.resSuccess(res, successMessage.success, rows[0]);
    } catch (error) {
        console.log(error)
        return Response.resError(res, errorMessage);
    }
}
async function sales (req, res) {
    let resp
    let sql = `select sum(grand_price) from receipt_detail`
    try {
        if(req.params.id){
            const value = [req.params.id] 
            sql += ' where seller_id = $1'
            console.log(sql)
            resp = await db.query(sql, value) 
            return Response.resSuccess(res, successMessage.success, resp.rows[0]);
        }else{
            resp = await db.query(sql)
            return Response.resSuccess(res, successMessage.success, resp.rows[0]);
        }
    } catch (error) {
        console.log(error)
        return Response.resError(res, errorMessage);
    }
}

async function totalAmount (req, res) {
    let sql = `select sum(amount) from receipt_detail `
    try {
        if(req.params.id){
            sql += 'where seller_id = $1'
            const value = [req.params.id]
            const { rows } = await db.query(sql, value)
            return Response.resSuccess(res, successMessage.success, rows[0]);
        }else{
            const { rows } = await db.query(sql)
            return Response.resSuccess(res, successMessage.success, rows[0]);
        }
    } catch (error) {
        console.log(error)
        return Response.resError(res, errorMessage);
    }
}

async function totalCustomer (req, res) {
    const sql = `
    select count(receipt.customer_id) from receipt
    inner join receipt_detail
        on receipt.receipt_id = receipt_detail.receipt_id
    where seller_id = $1
    `
    const value = [req.params.id]
    try {
        const { rows } = await db.query(sql, value)
        return Response.resSuccess(res, successMessage.success, rows[0]);
    } catch (error) {
        console.log(error)
        return Response.resError(res, errorMessage);
    }
}
async function topTenProducts (req, res) {
    let sql = `
    select 
        proid, product_name, sum(grand_price) as total_price, sum(amount) as total_amount
    from receipt_detail
    where seller_id = $1
    group by proid, product_name
    order by total_price desc
    `
    if(req.body.top){
        sql += 'limit 10'
    }
    const value = [req.params.id]
    try {
        const { rows } = await db.query(sql, value)
        return Response.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        console.log(error)
        return Response.resError(res, errorMessage);
    }
}
async function graph (req, res) {
    const reqBy = req.body.value
    const sql = `
    select extract(${reqBy} from receipt.createdate) as date, sum(receipt_detail.grand_price)
    from receipt_detail
    inner join receipt
        on receipt_detail.receipt_id = receipt.receipt_id
    where seller_id = $1
    group by extract(${reqBy} from receipt.createdate)
    `
    const value = [req.params.id]
    try {
        const { rows } = await db.query(sql, value)
        return Response.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        console.log(error)
        return Response.resError(res, errorMessage);
    }
}
async function users (req, res) {
    const reqBy = req.body.value
    const sql = `
    select extract(${reqBy} from receipt.createdate) as date, receipt.gender, count(receipt.gender) as total 
    from receipt
    inner join receipt_detail
        on receipt.receipt_id = receipt_detail.receipt_id
    where receipt_detail.seller_id = $1
    group by receipt_detail.seller_id, receipt.gender, extract(${reqBy} from receipt.createdate)
    `
    const value = [req.params.id]
    try {
        const { rows } = await db.query(sql, value)
        return Response.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        console.log(error)
        return Response.resError(res, errorMessage);
    }
}

