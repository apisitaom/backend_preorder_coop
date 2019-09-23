--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.admin (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    email character varying(128) NOT NULL,
    password character varying(128) NOT NULL,
    created_date timestamp without time zone DEFAULT now(),
    modified_date timestamp without time zone
);


ALTER TABLE public.admin OWNER TO aom;

--
-- Name: bank; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.bank (
    bankid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    bankname character varying(60),
    bankaccountname character varying(60),
    banknumber character varying(60)
);


ALTER TABLE public.bank OWNER TO aom;

--
-- Name: eventdetail; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.eventdetail (
    eventdeid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    totalproduct double precision,
    eventid uuid,
    proopid uuid
);


ALTER TABLE public.eventdetail OWNER TO aom;

--
-- Name: eventproduct; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.eventproduct (
    eventid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    timestart timestamp without time zone,
    timeend timestamp without time zone,
    countdowntime time without time zone
);


ALTER TABLE public.eventproduct OWNER TO aom;

--
-- Name: member; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.member (
    userid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    firstname character varying(50),
    lastname character varying(50),
    gender character varying(50),
    brithday date,
    addressuser character varying(255),
    subdistrict character varying(100),
    disstrict character varying(100),
    province character varying(100),
    zipcode character varying(100),
    photo character varying(100),
    email character varying(100),
    phone character varying(100),
    passworduser character varying(100)
);


ALTER TABLE public.member OWNER TO aom;

--
-- Name: orderdetail; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.orderdetail (
    orderdetailid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    amount integer,
    address character varying(500),
    phone character varying(20),
    phonenumber character varying(100),
    orderid uuid,
    proopid uuid
);


ALTER TABLE public.orderdetail OWNER TO aom;

--
-- Name: orderproduct; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.orderproduct (
    orderid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    userid uuid,
    payid uuid,
    shipid uuid,
    eventid uuid
);


ALTER TABLE public.orderproduct OWNER TO aom;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.payment (
    payid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    slip character varying(255),
    summary double precision,
    paystatusid uuid,
    datepayment timestamp without time zone
);


ALTER TABLE public.payment OWNER TO aom;

--
-- Name: paymentstatus; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.paymentstatus (
    paystatusid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    statusname character varying(50)
);


ALTER TABLE public.paymentstatus OWNER TO aom;

--
-- Name: product; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.product (
    proid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    proname character varying(50),
    prodetail character varying(50),
    photo text[],
    sellerid uuid,
    userid uuid
);


ALTER TABLE public.product OWNER TO aom;

--
-- Name: productoption; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.productoption (
    proopid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    sku character varying(60),
    price double precision,
    includingvat double precision,
    optionvalue json[],
    proid uuid,
    types character varying(60)
);


ALTER TABLE public.productoption OWNER TO aom;

--
-- Name: promptpay; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.promptpay (
    promptpayid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    promptpayname character varying(60),
    promptpaynumber character varying(60)
);


ALTER TABLE public.promptpay OWNER TO aom;

--
-- Name: receipt; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.receipt (
    receiptid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    orderid uuid
);


ALTER TABLE public.receipt OWNER TO aom;

--
-- Name: seller; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.seller (
    sellerid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    sellername character varying(50),
    address character varying(255),
    subdistrict character varying(255),
    district character varying(255),
    zipcode character varying(50),
    province character varying(255),
    phonenumber character varying(50),
    email character varying(255),
    sellerpassword character varying(60) NOT NULL,
    taxid character varying(60),
    photo character varying(60),
    bankid uuid,
    promptpayid uuid
);


ALTER TABLE public.seller OWNER TO aom;

--
-- Name: shipping; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.shipping (
    shipid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone,
    shiptrackno character varying(100),
    shipstatusid uuid
);


ALTER TABLE public.shipping OWNER TO aom;

--
-- Name: shippingstatus; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.shippingstatus (
    shipstatusid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    shippingstatusname character varying(50),
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone
);


ALTER TABLE public.shippingstatus OWNER TO aom;

--
-- Name: admin admin_email_key; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_email_key UNIQUE (email);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: bank bank_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (bankid);


--
-- Name: eventdetail eventdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.eventdetail
    ADD CONSTRAINT eventdetail_pkey PRIMARY KEY (eventdeid);


--
-- Name: eventproduct eventproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.eventproduct
    ADD CONSTRAINT eventproduct_pkey PRIMARY KEY (eventid);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (userid);


--
-- Name: orderdetail orderdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.orderdetail
    ADD CONSTRAINT orderdetail_pkey PRIMARY KEY (orderdetailid);


--
-- Name: orderproduct orderproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.orderproduct
    ADD CONSTRAINT orderproduct_pkey PRIMARY KEY (orderid);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payid);


--
-- Name: paymentstatus paymentstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.paymentstatus
    ADD CONSTRAINT paymentstatus_pkey PRIMARY KEY (paystatusid);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (proid);


--
-- Name: productoption productoption_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.productoption
    ADD CONSTRAINT productoption_pkey PRIMARY KEY (proopid);


--
-- Name: promptpay promptpay_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.promptpay
    ADD CONSTRAINT promptpay_pkey PRIMARY KEY (promptpayid);


--
-- Name: receipt receipt_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.receipt
    ADD CONSTRAINT receipt_pkey PRIMARY KEY (receiptid);


--
-- Name: seller seller_email_key; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_email_key UNIQUE (email);


--
-- Name: seller seller_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_pkey PRIMARY KEY (sellerid);


--
-- Name: shipping shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.shipping
    ADD CONSTRAINT shipping_pkey PRIMARY KEY (shipid);


--
-- Name: shippingstatus shippingstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.shippingstatus
    ADD CONSTRAINT shippingstatus_pkey PRIMARY KEY (shipstatusid);


--
-- Name: eventdetail eventdetail_eventid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.eventdetail
    ADD CONSTRAINT eventdetail_eventid_fkey FOREIGN KEY (eventid) REFERENCES public.eventproduct(eventid);


--
-- Name: eventdetail eventdetail_proopid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.eventdetail
    ADD CONSTRAINT eventdetail_proopid_fkey FOREIGN KEY (proopid) REFERENCES public.productoption(proopid);


--
-- Name: orderdetail orderdetail_orderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.orderdetail
    ADD CONSTRAINT orderdetail_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.orderproduct(orderid);


--
-- Name: orderdetail orderdetail_proopid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.orderdetail
    ADD CONSTRAINT orderdetail_proopid_fkey FOREIGN KEY (proopid) REFERENCES public.productoption(proopid);


--
-- Name: orderproduct orderproduct_eventid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.orderproduct
    ADD CONSTRAINT orderproduct_eventid_fkey FOREIGN KEY (eventid) REFERENCES public.eventproduct(eventid);


--
-- Name: orderproduct orderproduct_payid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.orderproduct
    ADD CONSTRAINT orderproduct_payid_fkey FOREIGN KEY (payid) REFERENCES public.payment(payid);


--
-- Name: orderproduct orderproduct_shipid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.orderproduct
    ADD CONSTRAINT orderproduct_shipid_fkey FOREIGN KEY (shipid) REFERENCES public.shipping(shipid);


--
-- Name: orderproduct orderproduct_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.orderproduct
    ADD CONSTRAINT orderproduct_userid_fkey FOREIGN KEY (userid) REFERENCES public.member(userid);


--
-- Name: payment payment_paystatusid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_paystatusid_fkey FOREIGN KEY (paystatusid) REFERENCES public.paymentstatus(paystatusid);


--
-- Name: product product_sellerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_sellerid_fkey FOREIGN KEY (sellerid) REFERENCES public.seller(sellerid);


--
-- Name: product product_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_userid_fkey FOREIGN KEY (userid) REFERENCES public.member(userid);


--
-- Name: productoption productoption_proid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.productoption
    ADD CONSTRAINT productoption_proid_fkey FOREIGN KEY (proid) REFERENCES public.product(proid);


--
-- Name: receipt receipt_orderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.receipt
    ADD CONSTRAINT receipt_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.orderproduct(orderid);


--
-- Name: seller seller_bankid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_bankid_fkey FOREIGN KEY (bankid) REFERENCES public.bank(bankid);


--
-- Name: seller seller_promptpayid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_promptpayid_fkey FOREIGN KEY (promptpayid) REFERENCES public.promptpay(promptpayid);


--
-- Name: shipping shipping_shipstatusid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.shipping
    ADD CONSTRAINT shipping_shipstatusid_fkey FOREIGN KEY (shipstatusid) REFERENCES public.shippingstatus(shipstatusid);


--
-- PostgreSQL database dump complete
--

