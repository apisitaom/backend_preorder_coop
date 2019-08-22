
--create extension if not exists pgcrypto;

--ADMIN
create table admin (
    id                  uuid primary key         default gen_random_uuid(),
    email               varchar(128) not null,
    password            varchar(128) not null,
    created_date        timestamp default now(),
    modified_date       timestamp
);
--------------------------1--------------------
--Shipping Status
create table ShippingStatus(
    shipStatusId        uuid primary key         default gen_random_uuid(),
    shippingStatusName  varchar(50) not null,
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
    firstName           varchar(50) not null,
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
    payStatusId         uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    statusName          varchar(50) not null
);

--Promptpay
create table Promptpay(
    promptpayId         uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    promptpayName       varchar(60) not null,
    promptpaynumber     varchar(60) not null
);

--Bank
create table Bank(
    bankId              uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
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
    datemodify          timestamp,
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

    bankId              uuid not null REFERENCES Bank(bankId),
    promptpayId         uuid not null REFERENCES Promptpay (promptpayId)
);

--Payment
create table Payment(
    payId               uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    slip                varchar(255),--photo
    summary             float not null,

    payStatusId         uuid not null,
    FOREIGN KEY (payStatusId) REFERENCES PaymentStatus (payStatusId)
);

--Shipping
create table Shipping(
    shipId              uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    shipTrackNo         varchar(100),

    shipStatusId        uuid not null,
    FOREIGN KEY (shipStatusId) REFERENCES shippingstatus (shipstatusid)
);

----------------------3--------------------
--Product 
create table Product(
    proId               uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    proName             varchar(50) not null,
    proDetail           varchar(50) not null,
    photo               varchar(255) not null,

    sellerId            uuid not null,
    FOREIGN key (sellerId) REFERENCES Seller (sellerId)
);

----------------------4--------------------
--Product Option
create table ProductOption(
    proOpId             uuid primary key         default gen_random_uuid(),
    createdate          timestamp default now(),
    active              boolean,
    datemodify          timestamp,
    sku                 varchar(60) not null,
    price               float not null,
    includingvat        float not null,
    optionvalue         json[],

    proId               uuid not null,
    FOREIGN key (proId) REFERENCES Product (proId)
);


--Event Detail
create table EventDetail(
    eventDeId           uuid primary key         default gen_random_uuid(),
    totalProduct        float,

    eventId             uuid not null,
    proOpId               uuid not null,
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

    userId              uuid not null,
    payId               uuid not null,
    shipId              uuid not null,
    eventId             uuid not null,
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

    orderId             uuid not null,
    FOREIGN key (orderId) REFERENCES OrderProduct(orderId)
);

--Order Detail
create table OrderDetail(
    orderDetailId       uuid primary key         default gen_random_uuid(),
    price               float not null,
    amount              integer not null,
    
    orderId             uuid not null,
    proOpId               uuid not null,
    FOREIGN KEY (orderId) REFERENCES OrderProduct(orderId),
    FOREIGN KEY (proOpId) REFERENCES ProductOption(proOpId)
);
