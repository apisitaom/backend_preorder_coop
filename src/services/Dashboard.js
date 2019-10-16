const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Response = require('../lib/Reposnce');
const moment = require('moment')
module.exports = {
    sales,
    totalAmount,
    totalCustomer,
    topTenProducts,
    graph,
    users,
    productSale,
    topTenSeller,
    proviceLists
}
function checkMount(val){
    switch(val){
        case 1: respValue = "January";
            break;
        case 2: respValue = "February";
            break;
        case 3: respValue = "March";
            break;
        case 4: respValue = "April";
            break;
        case 5: respValue = "May";
            break;
        case 6: respValue = "June"; 
            break;
        case 7: respValue = "July";
            break;
        case 8: respValue = "August";
            break;
        case 9: respValue = "September";
            break;
        case 10: respValue = "October";
            break;
        case 11: respValue = "November";
            break;
        case 12: respValue = "December";
            break;
        }
    return respValue
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
    let sql = `
    select count(receipt.customer_id) from receipt
    inner join receipt_detail
        on receipt.receipt_id = receipt_detail.receipt_id
    `
    const value = [req.params.id]
    try {
        if(req.params.id){
            sql += `where seller_id = $1`
            const { rows } = await db.query(sql, value)
            return Response.resSuccess(res, successMessage.success, rows[0]);
        }
        const { rows } = await db.query(sql)
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
    if(req.body.value === 'month'){
        date = 'extract(month from receipt.createdate)'
        dateValue = 'MMMM'
    }else if(req.body.value === 'year'){
        date = 'extract(year from receipt.createdate)'
        dateValue = 'YYYY'
    }else{
        date = 'receipt.day'
    }
    let sql = `
    select ${date} as date, sum(receipt_detail.grand_price)
    from receipt_detail
    inner join receipt
        on receipt_detail.receipt_id = receipt.receipt_id
    `
    const value = [req.params.id]
    let arrValue = []
    let data
    try {
        if(req.params.id){
            sql += `
            where seller_id = $1
            group by ${date}
            `
            const { rows } = await db.query(sql, value)
            rows.map( e => {
                if(req.body.value === "month"){
                    const a = checkMount(e.date)
                    data = {
                        "date": a,
                        "sum" : e.sum,
                    }
                }else if(req.body.value === "year"){
                    data = {
                        "date": e.date,
                        "sum" : e.sum,
                    }
                }else{
                    data = {
                        "date": e.date,
                        "sum" : e.sum,
                    }
                }
                arrValue.push(data)
            })
            return Response.resSuccess(res, successMessage.success, arrValue);
        }
        sql += `group by ${date}`
        const { rows } = await db.query(sql)
        rows.map( e => {
            const data = {
                "date": moment(e.date).format(dateValue),
                "sum" : e.sum
            }
            arrValue.push(data)
        })
        return Response.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        console.log(error)
        return Response.resError(res, errorMessage);
    }
}
async function users (req, res) {
    const day = new Date()
    const dd = String(day.getDate()).padStart(2, '0')
    const mm = String(day.getMonth() + 1).padStart(2, '0')
    const yyyy = day.getFullYear()
    let today
    if(req.body.value === 'month'){
        date = 'extract(month from receipt.createdate)'
        today = mm
    }else if(req.body.value === 'year'){
        date = 'extract(year from receipt.createdate)'
        today = yyyy
    }else{
        date = 'date(receipt.createdate)'
        today = yyyy + '-' + mm + '-' + dd
    }
    let sql = `
    select ${date} as date, receipt.gender, cast(count(receipt.gender) as integer) as total 
    from receipt
    inner join receipt_detail
        on receipt.receipt_id = receipt_detail.receipt_id
    `
    const value = [req.params.id]
    let selectJoin, userProcess, valueAge, group
    try {
        if(req.params.id){
            sql += `
                where receipt_detail.seller_id = $1 and ${date} = '${today}'
                group by receipt_detail.seller_id, receipt.gender, ${date}
            `
            selectJoin = await db.query(sql, value)
            userProcess = `where receipt_detail.seller_id = $1 and ${date} = '${today}'`
            group = `receipt_detail.seller_id,`
        }else{
            sql += `
                group by receipt.gender, ${date}
            `
            selectJoin = await db.query(sql)
            userProcess = ''
            group = ``
        }
        const sqlAge = `
            select ${date} as date, receipt.life_span, cast(count(receipt.life_span) as integer ) as total from receipt
            inner join receipt_detail
                on receipt.receipt_id = receipt_detail.receipt_id
            ${userProcess}
            group by receipt.life_span, ${group} ${date}
            `
        if(req.params.id){
            valueAge = await db.query(sqlAge, value)
        }else{
            valueAge = await db.query(sqlAge)
        }
        const valueRespone = {
            "age": valueAge.rows,
            "gender": selectJoin.rows
        }
        return Response.resSuccess(res, successMessage.success, valueRespone);
    } catch (error) {
        console.log(error)
        return Response.resError(res, errorMessage.saveError);
    }
}
async function topTenSeller (req, res) {
    let sql = `
    select 
        receipt_detail.seller_id, receipt_detail.seller_name, sum(receipt_detail.grand_price) as total_price, count(receipt.customer_id) as total_customer
    from receipt_detail
    inner join receipt
	    on receipt_detail.receipt_id = receipt.receipt_id
    `
    if(req.params.top){
        sql += `
        group by seller_id, seller_name
        order by total_price desc
        limit ${req.params.top}`
    }else if(req.body.value){
        sql += `where receipt_detail.seller_name like '${req.body.value}%'
        group by seller_id, seller_name
        order by total_price desc`
    }else{
        sql += `
        group by seller_id, seller_name
        order by total_price desc`
    }
    try {
        const { rows } = await db.query(sql)
        return Response.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        console.log(error)
        return Response.resError(res, errorMessage.saveError);
    }
}
async function proviceLists (req, res) {
    let sql = `
    select receipt.province, cast(count(receipt.customer_id) as integer) as total_user, sum(receipt_detail.grand_price) as total_price from receipt
    inner join receipt_detail
        on receipt.receipt_id = receipt_detail.receipt_id
    `
    try {
        if(req.body.value){
            sql += `
            where receipt.province like '${req.body.value}%'
            group by receipt.province
            order by total_price desc
            `
        }else{
            sql += `
            group by receipt.province
            order by total_price desc
            `
        }
        const { rows } = await db.query(sql)
        return Response.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        console.log(error)
        return Response.resError(res, errorMessage.saveError);
    }
}

// ยอดใช้ตามภูมิภาค แอดมิน
// ยอดขายทั้งจังหวัด
// select province, sum(grand_price) as total_price 
// from receipt
// group by receipt.province
// อายุ
// select 
// 	province, life_span, cast(count(customer_id) as integer) as total_customer
// from receipt
// group by receipt.province, life_span
// สินค้า
// select 
// 	receipt.province, receipt_detail.product_name, sum(receipt_detail.amount) as total_amount
// from receipt
// inner join receipt_detail
// 	on receipt.receipt_id = receipt_detail.receipt_id
// group by receipt.province, receipt_detail.product_name