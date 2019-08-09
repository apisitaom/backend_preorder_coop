const con = require('../config/config')
const Helper = require('./Helper')
//MOMENT TIME
const moment = require('moment')

const optionValue = {
    

    
    // create table OptionValue(
    //     optionValueId       serial primary key,
    //     createdate          timestamp,
    //     active              boolean,
    //     datemodify          timestamp,
    //     optionValueName     varchar(50) not null,
    //     OptionValue         varchar(50) not null,
    
    //     proOpId             integer not null,
    //     FOREIGN key (proOpId) REFERENCES ProductOption(proOpId)
    // );

    // create table ProductOption(
    //     proOpId             serial primary key,
    //     createdate          timestamp,
    //     active              boolean,
    //     datemodify          timestamp,
    //     sku                 varchar(60) not null,
    //     price               float not null,
    
    //     proId               integer not null,
    //     FOREIGN key (proId) REFERENCES Product (proId)
    // );



  


}

exports.optionValue = optionValue