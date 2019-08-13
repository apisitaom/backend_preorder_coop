const con = require('../config/config')

const Product = {
    //GET POPUP
async getPopup(req,res){
    
    const getPopup = `select product.photo,product.proname,productoption.price,optionvalue.optionvaluename,optionvalue.optionvalue
    from product inner join productoption on product.proid = productoption.proopid inner join  optionvalue on optionvalue.proopid = productoption.proopid where productoption.sku = $1`;
    try{
        const { rows } = await  con.pool.query(getPopup);
        return res.status(200).send({'message':'get popup success',rows});
    }catch(error){
        return res.status(400).send({'message':'error'});
        }

    }
}

module.exports = {Product}