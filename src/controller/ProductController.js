const con = require('../config/config')

const Product = {
    //GET POPUP
async getPopup(req,res){
    if(req.params.id == ''){
        return res.status(200).send({'message':'error product id null'});
    }
    const getPopup = `select product.photo,product.proname,productoption.price,optionvalue.optionvaluename,optionvalue.optionvalue
    from product inner join productoption on product.proid = productoption.proid inner join  optionvalue on optionvalue.proopid = productoption.proopid where product.proid = $1 and product.active = true`;
    try{
        const {rows} = await  con.pool.query(getPopup,[req.params.id]);

        console.log('get product data');

        return res.status(200).send({rows});
    }catch(error){
        return res.status(400).send({'message':'error'});
        }
    }
}

module.exports = {Product}
