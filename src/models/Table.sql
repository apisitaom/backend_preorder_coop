
--create extension if not exists pgcrypto;

--ADMIN
create table admin (
    id                  uuid primary key         default gen_random_uuid(),
    email               varchar(128) not null UNIQUE,
    password            varchar(128) not null,
    created_date        timestamp default now(),
    modified_date       timestamp
    
    --IS (**FK**) for table bank and promptpay
    bankid              uuid,
    promptpayid         uuid
);
--------------------------1--------------------
--Shipping Status
create table ShippingStatus(
    shipStatusId        uuid primary key         default gen_random_uuid(),
    shippingStatusName  varchar(50)  ,
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp
);

--Event
create table EventProduct(
    eventId             uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    timeStart           timestamp,
    timeEnd             timestamp,
    countDownTime       time
);

--User
create table Member(
    userId              uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    firstname           varchar(50)  ,
    lastName            varchar(50)  ,
    gender              varchar(50)  ,
    brithDay            date,
    addressUser         varchar(255),
    subdistrict         varchar(100),
    disstrict           varchar(100),
    province            varchar(100),
    zipcode             varchar(100),
    photo               varchar(100),
    email               varchar(100) UNIQUE,
    phone               varchar(100),
    passwordUser        varchar(100)
);

--Payment Status
create table PaymentStatus(
    payStatusId         uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    statusName          varchar(50)  
);

--Promptpay
create table Promptpay(
    promptpayId         uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    promptpayName       varchar(60)  ,
    promptpaynumber     varchar(60)  
);

--Bank
create table Bank(
    bankId              uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    bankName            varchar(60)  ,
    bankAccountname     varchar(60)  ,
    bankNumber          varchar(60)  
);

----------------------2--------------------

--Seller 
create table Seller(
    sellerId            uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    sellerName          varchar(50)  null,
    address             varchar(255) null,
    subdistrict         varchar(255) null,
    district            varchar(255) null,
    zipcode             varchar(50) null,
    province            varchar(255) null,  
    phoneNumber         varchar(50)  null,
    email               varchar(255) UNIQUE,
    sellerPassword      varchar(60)  not null,
    taxId               varchar(60)  ,
    photo               varchar(60),

    bankId              uuid   REFERENCES Bank(bankId),
    promptpayId         uuid   REFERENCES Promptpay (promptpayId)
);

--Payment
create table Payment(
    payId               uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    slip                varchar(255),--photo
    summary             float  ,
    datepayment         timestamp,
    payStatusId         uuid  ,
    FOREIGN KEY (payStatusId) REFERENCES PaymentStatus (payStatusId)
);

--Shipping
create table Shipping(
    shipId              uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    shipTrackNo         varchar(100),

    shipStatusId        uuid  ,
    FOREIGN KEY (shipStatusId) REFERENCES shippingstatus (shipstatusid)
);

----------------------3--------------------
--Product 
create table Product(
    proId               uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    proName             varchar(50)  ,
    proDetail           varchar(50)  ,
    photo               text [] ,
           
    timeStart           timestamp,
    timeEnd             timestamp,

    sellerId            uuid  ,
    userid              uuid ,
    FOREIGN key (userid) REFERENCES Member (userId),
    FOREIGN key (sellerId) REFERENCES Seller (sellerId)
);

----------------------4--------------------
--Product Option
create table ProductOption(
    proOpId             uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    sku                 varchar(60),
    price               float,
    includingvat        float,
    optionvalue         json[],
        --กำหนดว่าสินค้าเป็น pre_order หรือไม่
    types            varchar(60),
    totalProduct        float,

    proId               uuid ,
    FOREIGN key (proId) REFERENCES Product (proId)
);


--Event Detail
create table EventDetail(
    eventDeId           uuid primary key         default gen_random_uuid(),
    totalProduct        float,

    eventId             uuid  ,
    proOpId               uuid  ,
    FOREIGN key (eventId) REFERENCES EventProduct(eventId),
    FOREIGN key (proOpId) REFERENCES ProductOption(proOpId)
);

----------------------5--------------------
--Order
create table OrderProduct(
    orderId             uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,

    userId              uuid  ,
    payId               uuid  ,
    shipId              uuid  ,
    eventId             uuid  ,
    FOREIGN KEY (userId) REFERENCES Member(userId),
    FOREIGN KEY (payId) REFERENCES Payment(payId),
    FOREIGN KEY (shipId) REFERENCES Shipping(shipId),
    FOREIGN KEY (eventId) REFERENCES EventProduct(eventId)
);
----------------------6--------------------

--Receipt
create table Receipt(
    receiptid           uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,

    orderId             uuid  ,
    FOREIGN key (orderId) REFERENCES OrderProduct(orderId)
);

--Order Detail
create table OrderDetail(
    orderDetailId       uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,    
    amount              integer,
    address             varchar(500),
    phone               varchar(50),

    orderdetails             uuid  ,
    FOREIGN KEY (proOpId) REFERENCES ProductOption(proOpId)
    FOREIGN KEY (orderId) REFERENCES OrderProduct(orderId),
);
