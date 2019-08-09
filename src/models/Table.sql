create table a (
ida serial primary key,
name varchar(50)
);
create table b (
idb serial primary key,
name varchar(50),

ida integer not null,
FOREIGN key (ida) REFERENCES a(ida)
);
create table c (
idc serial primary key,
name varchar(50),

idb integer not null,
FOREIGN key (idb) REFERENCES b(idb)
);



--ADMIN
create table users (
    id uuid primary key,
    email varchar(128) not null,
    password varchar(128) not null,
    created_date timestamp,
    modified_date timestamp
);
--------------------------1--------------------
--Shipping Status
create table ShippingStatus(
    shipStatusId        serial primary key,
    shippingStatusName  varchar(50) not null,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp
);

--Event
create table EventProduct(
    eventId             serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,
    timeStart           timestamp,
    timeEnd             timestamp,
    countDownTime       timestamp
);

--User
create table Member(
    userId              serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,
    fristName           varchar(50) not null,
    lastName            varchar(50) not null,
    gender              varchar(50) not null,
    brithDay            date,
    addressUser         varchar(255),
    subdistrict         varchar(100),
    disstrict           varchar(100),
    province            varchar(100),
    zipcode             varchar(100),
    photo               varchar(100),
    email               varchar(100),
    passwordUser        varchar(100)
);

--Payment Status
create table PaymentStatus(
    payStatusId         serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,
    statusName          varchar(50) not null
);

--Promptpay
create table Promptpay(
    promptpayId         serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,
    promptpayName       varchar(60) not null,
    promptpaynumber     varchar(60) not null
);

--Bank
create table Bank(
    bankId              serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,
    bankName            varchar(60) not null,
    bankAccountname     varchar(60) not null,
    bankNumber          varchar(60) not null
);

----------------------2--------------------

--Seller 
create table Seller(
    sellerId            uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp default now(),
    sellerName          varchar(50) not null,
    address             varchar(255) null,
    subdistrict         varchar(255) null,
    district            varchar(255) null,
    zipcode             varchar(50) null,
    province            varchar(255) null,  
    phoneNumber         varchar(50) not null,
    email               varchar(255) UNIQUE,
    sellerPassword      varchar(60) not null,
    taxId               varchar(60) not null,
    photo               varchar(255) null,

    bankId              integer not null REFERENCES Bank(bankId),
    promptpayId integer not null REFERENCES Promptpay (promptpayId)
);

--Payment
create table Payment(
    payId               serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,
    slip                varchar(255),--photo
    summary             float not null,

    payStatusId         integer not null,
    FOREIGN KEY (payStatusId) REFERENCES PaymentStatus (payStatusId)
);

--Shipping
create table Shipping(
    shipId              serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,
    shipTrackNo         varchar(100),

    shipStatusId        integer not null,
    FOREIGN KEY (shipStatusId) REFERENCES shippingstatus (shipstatusid)
);

----------------------3--------------------
--Product 
create table Product(
    proId               serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,
    proName             varchar(50) not null,
    proDetail           varchar(50) not null,
    photo               varchar(255) not null,

    sellerId            integer not null,
    FOREIGN key (sellerId) REFERENCES Seller (sellerId)
);

----------------------4--------------------

--Event Detail
create table EventDetail(
    eventDeId           serial primary key,
    totalProduct        float,

    eventId             integer not null,
    proId               integer not null,
    FOREIGN key (eventId) REFERENCES EventProduct(eventId),
    FOREIGN key (proId) REFERENCES Product(proId)
);

--Product Option
create table ProductOption(
    proOpId             serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,
    picture             varchar(255),
    sku                 varchar(60) not null,
    price               float not null,

    proId               integer not null,
    FOREIGN key (proId) REFERENCES Product (proId)
);
----------------------5--------------------
--Order
create table OrderProduct(
    orderId             serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,
    summary             float not null,

    userId              integer not null,
    payId               integer not null,
    shipId              integer not null,
    eventId             integer not null,
    FOREIGN KEY (userId) REFERENCES Member(userId),
    FOREIGN KEY (payId) REFERENCES Payment(payId),
    FOREIGN KEY (shipId) REFERENCES Shipping(shipId),
    FOREIGN KEY (eventId) REFERENCES EventProduct(eventId)
);

--Option Value
create table OptionValue(
    optionValueId       serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,
    optionValueName     text[] not null,
    OptionValue         text[] not null,

    proOpId             integer not null,
    FOREIGN key (proOpId) REFERENCES ProductOption(proOpId)
);
----------------------6--------------------

--Receipt
create table Receipt(
    receiptid           serial primary key,
    createdate          timestamp,
    active              boolean,
    datemodify          timestamp,

    orderId             integer not null,
    FOREIGN key (orderId) REFERENCES OrderProduct(orderId)
);

--Order Detail
create table OrderDetail(
    orderDetailId       serial primary key,
    price               float not null,
    amount              integer not null,
    
    orderId             integer not null,
    proId               integer not null,
    FOREIGN KEY (orderId) REFERENCES OrderProduct(orderId),
    FOREIGN KEY (proId) REFERENCES Product(proId)
);



