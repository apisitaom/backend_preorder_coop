const con = require('../config/config')

const Product = {
    //GET POPUP
async getPopup(req,res){
    
    const getProduct = ''; //picture|productname|price
    const getOptionvalue = ''; //optionname|optionvalue

    // select seller.sellername,seller.address,seller.phonenumber,seller.email,seller.taxid,bank.bankname,bank.bankaccountname,promptpay.promptpayname from seller inner join bank on bank.bankid = seller.sellerid inner join promptpay on promptpay.promptpayid = seller.sellerid;
    const getPopup = `select product.photo,product.proname,productoption.price,optionvalue.optionvaluename[1],optionvalue.optionvalue[1] 
    from product inner join productoption on product.proid = productoption.proopid inner join  optionvalue on optionvalue.proopid = productoption.proopid where product.proid = 1`;
    // optionvalue
    try{
        con.pool.query(getPopup);
        res.status(200).send({'message':'get data popup product success'});
    }catch(error){
        return res.status(400).send({'message':'error'});
        }
    }
}

module.exports = {Product}