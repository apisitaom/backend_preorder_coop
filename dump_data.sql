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
    phone character varying(100),
    passworduser character varying(100),
    email character varying(100)
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
    orderid uuid,
    proopid uuid,
    phone character varying(50),
    proopids text[],
    disstrict character varying(100),
    province character varying(100),
    zipcode character varying(100),
    amounts text[]
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
    eventid uuid,
    sellerid text[]
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
    datepayment timestamp without time zone,
    paystatusid integer,
    summarycheck double precision
);


ALTER TABLE public.payment OWNER TO aom;

--
-- Name: paymentstatus; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.paymentstatus (
    paystatusid integer NOT NULL,
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
    userid uuid,
    timestart timestamp without time zone,
    timeend timestamp without time zone,
    category character varying(50)
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
    price double precision,
    includingvat double precision,
    optionvalue json[],
    proid uuid,
    types character varying(60),
    totalproduct double precision,
    sku character varying(60)
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
    shipstatusid integer
);


ALTER TABLE public.shipping OWNER TO aom;

--
-- Name: shippingstatus; Type: TABLE; Schema: public; Owner: aom
--

CREATE TABLE public.shippingstatus (
    shipstatusid integer NOT NULL,
    shippingstatusname character varying(50),
    createdate timestamp without time zone DEFAULT now(),
    active boolean,
    datemodify timestamp without time zone
);


ALTER TABLE public.shippingstatus OWNER TO aom;

--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.admin (id, email, password, created_date, modified_date) FROM stdin;
41126b36-7aa6-4cd5-a9d0-d51268adac99	test@gmail.com	12345	2019-10-09 14:01:56.03689	\N
\.


--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.bank (bankid, createdate, active, datemodify, bankname, bankaccountname, banknumber) FROM stdin;
8d47a16b-1244-4e81-a022-eb47526dd030	2019-10-08 16:16:35	t	2019-10-10 12:54:51	\N	\N	\N
604dc9b0-f9d4-4329-8873-e359bdede88a	2019-10-08 14:15:04	t	2019-10-10 14:34:17	\N	\N	\N
f6896d33-652f-40c0-bb2b-c78076ea8ce5	2019-10-10 15:08:56	t	2019-10-10 15:08:56	Bea jin	SCB	25962348512
c596bb5f-76c2-4dfa-9af5-dc495f916e0c	2019-10-10 15:33:10	t	2019-10-10 15:33:10	Daniel K	TMB	963525155252
\.


--
-- Data for Name: eventdetail; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.eventdetail (eventdeid, totalproduct, eventid, proopid) FROM stdin;
\.


--
-- Data for Name: eventproduct; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.eventproduct (eventid, createdate, active, datemodify, timestart, timeend, countdowntime) FROM stdin;
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.member (userid, createdate, active, datemodify, firstname, lastname, gender, brithday, addressuser, subdistrict, disstrict, province, zipcode, photo, phone, passworduser, email) FROM stdin;
adde16c5-84a9-429e-8527-a4a954bd2546	2019-10-08 14:16:08	t	2019-10-08 14:16:08	dedee	krasihom	หญิง	2019-10-01	\N	\N	\N	\N	\N	\N	\N	$2b$08$7tF5ubSyDQRyPr.fxJ.qPOjnpp/kOPlvxnQrZ4ccj7kkzUkZ91PL.	iteasytime@hotmail.com
49121392-a55b-4283-ae7d-947a1fd7bba4	2019-10-08 14:18:08	t	2019-10-08 14:18:08	apisit	prompha	man	2016-06-06	BKK	big	bigger	Bankok	30000	\N	0933347977	$2b$08$7uVPoFdyj9EntZ4UYAiTZePHGTExGMMOd7KWpms3Yj2ZNI7.izNjS	toa@gmail.com
1965fdc2-4a62-4804-be4f-a31711862295	2019-10-08 14:25:33	t	2019-10-08 14:25:33	ite	fds	ชาย	2019-10-29	\N	\N	\N	\N	\N	\N	\N	$2b$08$TLaW0JeQjwWr933y2Oq/Aeae1XosGKlMfg4QQwyIbOlDw1kMdXDBO	1
a4fd8063-4746-4b2e-8a22-4424470c4d28	2019-10-08 14:28:14	t	2019-10-08 14:28:14	xxx	xx	ชาย	2019-10-08	\N	\N	\N	\N	\N	\N	\N	$2b$08$JNvhT1LMa8Xyqk0npcHfTOIUgAqEyacZcmqmkXMjrQIM24REJ4fJi	xx
e2910ae9-f2aa-48e0-bda2-ebe83cad2a92	2019-10-08 14:31:50	t	2019-10-08 14:31:50	x	x	อื่นๆ	2019-10-29	\N	\N	\N	\N	\N	\N	\N	$2b$08$CaH5GOtu5Y0cB8KenflrW.L7bmh4rk6RHD5U.y6OmBHmIN7BP4M7q	z
72ed01b7-97e5-4521-be27-b599c4b65d0c	2019-10-08 14:33:30	t	2019-10-08 14:33:30	x	x	ชาย	2019-10-29	\N	\N	\N	\N	\N	\N	\N	$2b$08$BjyuY0eAVs0nt78cey9zguHgOmNXq9scxjPbTRySma1lIjK9ohf/S	xxx
f1414bf8-eb8d-4db4-8424-143ab5538694	2019-10-08 14:38:28	t	2019-10-08 14:38:28	xqewqwe	xqweqweqwe	ชาย	2019-10-29	\N	\N	\N	\N	\N	\N	\N	$2b$08$ddi0mVh0L/EyARDQmE6Zd.ibmTOVgFcC0yTIMTSM/swtnmGDQ/7AC	xxxsss
ade4ddb5-4d3c-4754-b50d-67e9b014e00b	2019-10-08 14:42:47	t	2019-10-08 14:42:47	xxxxx	xxxxxxx	ชาย	2019-10-22	\N	\N	\N	\N	\N	\N	\N	$2b$08$35E4XPn9u0qsuxiOJaD1KO1dDR5SOklMigeLvU9d0wmG5qw6crx/K	xxxx
022a4a10-5053-4329-948f-c3cd49d075f0	2019-10-08 14:46:19	t	2019-10-08 14:46:19	uuuuYYY	yyy	ชาย	2019-10-08	\N	\N	\N	\N	\N	\N	\N	$2b$08$pDeLGrkfND5cosnUfG73sOX0j1aZD0LOLZu08c6W3/s49UOqQsz3q	mmmm
efac7455-c1dd-4930-9b0f-627e6eea74a6	2019-10-08 14:47:08	t	2019-10-08 14:47:08	iiiii	11111	หญิง	2019-10-30	\N	\N	\N	\N	\N	\N	\N	$2b$08$vkJcwl8btyL0hZHmQqCdh.Ne//58J.Ly6TGJJkeEaWcOUlRXtCbH2	xcxcxccx
ea804804-4248-4e36-b2ec-8ca2de7f9918	2019-10-08 14:50:39	t	2019-10-08 14:50:39	aasdasdasd	asdasdasd	ชาย	2019-10-08	\N	\N	\N	\N	\N	\N	\N	$2b$08$BLVdSisA30CUJYzb6HRMf.bI9/Tvpdghsx00BUzgn1vWdnDjMgbxq	zxcczx
f1661738-0ef2-4eea-938d-92c70d913e98	2019-10-08 17:09:00	t	2019-10-08 17:09:00	พิชญาภรณ์	กระสินธุ์หอม	หญิง	2019-10-01	\N	\N	\N	\N	\N	\N	\N	$2b$08$6nXrKuan4dnctY3g38Rpduiy1X188hCQBO3CwaSt4acI3gFHRI1KG	q@q.com
71133079-afeb-4193-80ec-ec97c61959c7	2019-10-09 14:59:46	t	2019-10-09 14:59:46	fitri2	raso	ชาย	2019-10-08	x	x	x	x	x	\N	x	$2b$08$j4XvKXsPBIVSzC9OIEuQZeBGgpjcuBg.IW4uN63JKzgWxboxcXp6.	u10372
6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	2019-10-08 14:51:08	t	2019-10-08 14:51:08	ณเดช	ราโซ	ชาย	2019-10-02	11	พหลโยธิน 29	จตุจักร	กรุงเทพมหานคร	94000	picture-1570604204412.jpg	0899999999	$2b$08$DpWcBFJTdZbk3BwQluTWAOkkzNn1RW.3gDJWUOhitVV6gJ.3lJoIi	fitto@gmail.com
0114cf7f-2ae4-4c87-802d-905785ee80ea	2019-10-09 11:18:04	t	2019-10-09 11:18:04	พิชญาภรณ์	กระสินธุ์หอม	หญิง	1997-11-18	181 หมู่ที่13	โนนแดง	โนนแดง	นครราชสีมา	30360	picture-1570680414444.jpg	0880509035	$2b$08$w12ufZU237HwUaQLQfbdgODQaJ2OBrc9mExoRWIfG8ugDlT9Sizh6	b5970353@gmail.com
459f3630-dd41-4ceb-939c-4860e1994c12	2019-10-10 12:36:27	t	2019-10-10 12:36:27	Palisa	Sriralerng	หญิง	2019-09-05	Suranaree	Mueng	Mueng	Korat	30000	picture-1570685847789.jpg	0880509035	$2b$08$dt4hip9oIysIkHD.ZdBYLebAq1ilUXhsLSfneQRaD8r2289QX3C.G	mind@gmail.com
\.


--
-- Data for Name: orderdetail; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.orderdetail (orderdetailid, createdate, active, datemodify, amount, address, orderid, proopid, phone, proopids, disstrict, province, zipcode, amounts) FROM stdin;
b5717704-b824-43a1-a3fb-041594b9526c	2019-10-08 14:24:13.668418	t	\N	\N	หฟดำเพหะก ๆำกไฟำพถะพัี	22b7ecd7-c0d2-4ce3-8b1f-d3b32f923e9d	\N	-ไพ/-ภะด/	{e3d80bdb-a7d5-4b68-a843-b1fc01f5ee36}	-ภะภ-ะ	ำๆพไำะถพัะ	ะภ-ะ	{1}
36922f5e-1509-48a4-acb4-c1fdec69ece3	2019-10-08 14:25:20.922115	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	f079806c-0d52-4df8-89cb-3c0def152d52	\N	0933347977	{60595e64-28e7-440a-b442-7369bbf84b5a,6ef43b86-7862-4a62-99f3-d5eb49a170f4}	พนา	bankkok	37180	{9,12}
f5f0c737-ae31-4ee9-85ee-c3646fc5d91f	2019-10-08 15:18:49.669087	t	\N	\N	13 พหลโยธิน 29	8a7f7462-05a8-4f85-9a07-717b8ef3946f	\N	0822222222	{e3d80bdb-a7d5-4b68-a843-b1fc01f5ee36}	จตุจักร	กทม	14000	{1}
7b021a55-f1c0-4923-861d-c6d9c2a118c6	2019-10-08 15:18:49.572286	t	\N	\N	null null	3bf3dd87-03ca-4199-a679-b892252dd7fe	\N	\N	{e3d80bdb-a7d5-4b68-a843-b1fc01f5ee36}	\N	\N	\N	{1}
40373cfa-2f98-4f4e-b53c-ccdf84464ace	2019-10-08 16:23:31.334902	t	\N	\N	sut ee	440cf0e9-ef44-493c-9456-25e70ad84be6	\N	0888888888	{e3d80bdb-a7d5-4b68-a843-b1fc01f5ee36,0caf9fe6-220a-4adc-b75a-618c18221056}	we	korat	30000	{3,1}
75fac205-52c0-422d-a02f-72acadae8dfb	2019-10-08 16:27:41.598365	t	\N	\N	11 พหลโยธิน 29	50320ee7-5285-427c-8c85-5827cb319b2f	\N	0899999999	{}	จตุจักร	กรุงเทพมหานคร	94000	{}
551a5f04-7ec0-4fb0-8c64-7994710f3eab	2019-10-08 16:31:04.721137	t	\N	\N	11 พหลโยธิน 29	3b50279f-1474-4b22-952b-2b7a151619ed	\N	0899999999	{e3d80bdb-a7d5-4b68-a843-b1fc01f5ee36}	จตุจักร	กรุงเทพมหานคร	94000	{1}
701bc032-3659-495b-bd7e-ea5ec420126f	2019-10-08 16:52:09.319132	t	\N	\N	wdqwqwd ee	849c5db8-ec26-44a1-9822-ed476dcbdb09	\N	0813568155	{df8bb2f9-98ec-41ce-ba38-3106fc3c291d,e3d80bdb-a7d5-4b68-a843-b1fc01f5ee36}	dqwdqw	greg	12345	{1,1}
3494947a-22f2-401d-b06b-f1e73cb47ec4	2019-10-08 17:15:04.443755	t	\N	\N	sut dqwdwq	37bd9f8e-c38e-4eaa-a339-8d1e5b0a670b	\N	0880509035	{7fe46d0c-e842-404f-8fe6-1d91e4d57eff,938ec6e1-7bee-4a65-815c-949c1758a7b6}	sut	korat	30000	{1,1}
203c93ba-25d7-4f05-aca9-36565ce0f905	2019-10-08 17:37:19.078082	t	\N	\N	11 พหลโยธิน 29	83a4359e-dd71-4c1e-9c48-3451f59dc50a	\N	0899999999	{60595e64-28e7-440a-b442-7369bbf84b5a,e3d80bdb-a7d5-4b68-a843-b1fc01f5ee36,0caf9fe6-220a-4adc-b75a-618c18221056,df8bb2f9-98ec-41ce-ba38-3106fc3c291d,74e552b6-c654-4722-9a43-7b582f3befa0,7fe46d0c-e842-404f-8fe6-1d91e4d57eff,938ec6e1-7bee-4a65-815c-949c1758a7b6,2f39ecf7-dcec-4b7b-9519-e143219d5c79}	จตุจักร	กรุงเทพมหานคร	94000	{1,1,1,1,1,1,1,1}
067ac93a-3c57-4a54-be7d-4ffe22d9a141	2019-10-09 11:19:19.824414	t	\N	\N	181 หมู่ที่13 โนนแดง	8776ff36-43f2-4a9a-9c02-d84258b3d610	\N	0880509035	{aa814f5f-8af5-4c53-943d-a0ab54e018c6,1e456eed-7a13-49cd-bd18-d8326e0ecfae}	โนนแดง	นครราชสีมา	30360	{1,1}
e75f39b9-0b2b-434e-84f2-2e84f4b4acf4	2019-10-09 11:49:57.273366	t	\N	\N	181 หมู่ที่13 โนนแดง	21a0aa5b-d426-4f9b-9746-7096a0c1ac4b	\N	0880509035	{1e456eed-7a13-49cd-bd18-d8326e0ecfae}	โนนแดง	นครราชสีมา	30360	{1}
f814f960-cdfe-4ccf-b923-5aea2fe86e68	2019-10-09 12:29:18.357917	t	\N	\N	150 หมู่ที่13 โนนแดง	172eb90b-283a-4d7d-90fb-d6a3fd8ec8ea	\N	044485211	{3eba6edb-ec04-480b-8dea-dcc5453fe0f4,aa814f5f-8af5-4c53-943d-a0ab54e018c6}	โนนแดง	นครราชสีมา	30360	{1,1}
b80cd342-bac5-4514-a45d-9b8cbb50b8fc	2019-10-09 13:40:55.079716	t	\N	\N	11 พหลโยธิน 29	33a922eb-de22-42e1-b0c0-f52a960d8c6a	\N	0899999999	{1e456eed-7a13-49cd-bd18-d8326e0ecfae,aa814f5f-8af5-4c53-943d-a0ab54e018c6}	จตุจักร	กรุงเทพมหานคร	94000	{1,1}
be592b6d-5fac-4f41-b2fd-1649762fdda4	2019-10-09 13:52:42.589281	t	\N	\N	11 พหลโยธิน 29	125d5548-1a8c-4dd3-9a5b-e0969811857a	\N	0899999999	{1e456eed-7a13-49cd-bd18-d8326e0ecfae}	จตุจักร	กรุงเทพมหานคร	94000	{1}
63ccf589-946d-424e-b5ef-755b89b0a97d	2019-10-09 15:00:34.284408	t	\N	\N	x x	e1e6bf85-7cee-48f8-bb2d-ff4d5d2365ce	\N	x	{1e456eed-7a13-49cd-bd18-d8326e0ecfae}	x	x	x	{1}
188f5412-ab96-4144-b55a-4cffde05fa7b	2019-10-09 16:16:39.439694	t	\N	\N	11 พหลโยธิน 29	1bee3552-ec5e-4414-8940-b3991f50104c	\N	0899999999	{aa814f5f-8af5-4c53-943d-a0ab54e018c6}	จตุจักร	กรุงเทพมหานคร	94000	{1}
8917a160-6c70-4449-97c3-9c57a5ff9a0a	2019-10-09 16:16:59.05721	t	\N	\N	11 พหลโยธิน 29	57b2b82b-8bf6-47d1-a963-32577ee64221	\N	0899999999	{3eba6edb-ec04-480b-8dea-dcc5453fe0f4}	จตุจักร	กรุงเทพมหานคร	94000	{1}
2009bba1-96b8-4769-9942-211b41bfdc45	2019-10-10 12:09:22.648013	t	\N	\N	181 หมู่ที่13 โนนแดง	fd5ac993-6d1f-403a-b0ad-d3e8d9174973	\N	0880509035	{01065ea7-8823-4048-85cf-aa30fe119538}	โนนแดง	นครราชสีมา	30360	{1}
fc266e0a-d78d-4028-92d2-a34c277e3048	2019-10-10 12:11:03.599683	t	\N	\N	181 หมู่ที่13 โนนแดง	571f2302-f7f4-4932-a886-80a77c1637c4	\N	0880509035	{b6b7dadb-d667-4a2f-9f4a-12b5f1dfc5fe}	โนนแดง	นครราชสีมา	30360	{1}
faea211d-41d6-4c1c-97c9-ecbd452b3207	2019-10-10 12:12:46.916992	t	\N	\N	181 หมู่ที่13 โนนแดง	07b247ad-0145-4117-a574-2ae884d73694	\N	0880509035	{764638f1-280a-4ce5-b908-cc92f0169560}	โนนแดง	นครราชสีมา	30360	{1}
69555498-d92a-4aa6-8f2e-71e636e9edc6	2019-10-10 12:32:44.764387	t	\N	\N	181 หมู่ที่13 โนนแดง	53db66ac-753e-4031-900a-0856b23711e5	\N	0880509035	{4f4c0b31-15f9-48dd-941f-694bcdeaac1d}	โนนแดง	นครราชสีมา	30360	{1}
636de45e-8864-46ab-b303-1731409f64df	2019-10-10 12:37:44.06824	t	\N	\N	Suranaree Mueng	1272907b-182b-469d-998a-54dfeae42a52	\N	0880509035	{01065ea7-8823-4048-85cf-aa30fe119538}	Mueng	Korat	30000	{1}
30f81234-f412-41f6-b9b8-2b3b4942fa7b	2019-10-10 12:45:10.60282	t	\N	\N	Suranaree Mueng	c970229d-1a23-4008-a450-9793fc46f4cb	\N	0880509035	{d46dfdb2-9e5a-44e4-9f7f-12ceb69fea57}	Mueng	Korat	30000	{1}
4393d0f8-1904-4847-8cfa-cfd04be33348	2019-10-10 15:10:37.763225	t	\N	\N	Suranaree 111 Mueng	0a36579a-d68f-4676-8698-48e07716af6d	\N	0880509035	{4f4c0b31-15f9-48dd-941f-694bcdeaac1d}	Mueng	Korat	30000	{1}
e42bf9c4-49a8-4dc6-89d4-54a4f2449538	2019-10-10 16:19:24.388101	t	\N	\N	Suranaree Mueng	f1976b93-e83e-41f9-81fa-6bb927d661eb	\N	0880509035	{9cffea1b-3292-4007-bf3d-225333ace1c9}	Mueng	Korat	30000	{1}
077c5d3f-c9d2-47d3-a3b9-cedc6fd8dc6e	2019-10-10 16:19:36.232247	t	\N	\N	Suranaree Mueng	dd9c3852-ee45-4512-b036-380e960bc5b8	\N	0880509035	{5eb8060c-41bf-4dd8-8bbb-ad0797e34074}	Mueng	Korat	30000	{1}
\.


--
-- Data for Name: orderproduct; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.orderproduct (orderid, createdate, active, datemodify, userid, payid, shipid, eventid, sellerid) FROM stdin;
f079806c-0d52-4df8-89cb-3c0def152d52	2019-10-08 14:25:20.88536	t	\N	49121392-a55b-4283-ae7d-947a1fd7bba4	d8b7619f-1581-4590-b0c9-411ca1323692	\N	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3,eb27cc47-fd1b-455f-aae0-bb15db16fff3}
33a922eb-de22-42e1-b0c0-f52a960d8c6a	2019-10-09 13:40:55.042913	t	\N	6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	07148724-b5d1-44c7-a904-450f651745f7	594ccb38-7f4a-4630-a800-f79169fe4ca4	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3,705f4aa2-d1d0-4550-ba18-3ae328f57673}
8a7f7462-05a8-4f85-9a07-717b8ef3946f	2019-10-08 15:18:49.620137	t	\N	6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	340e3ae5-586b-402e-9160-2c93b8292087	0ed7b1c5-859c-4143-a52a-dc84c97a1f08	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3}
3bf3dd87-03ca-4199-a679-b892252dd7fe	2019-10-08 15:18:49.572286	t	\N	adde16c5-84a9-429e-8527-a4a954bd2546	ea9d1d0a-9caf-48b6-81a4-1b101dba946f	8f01c290-0264-41bc-b34d-a459cfd122d6	\N	\N
440cf0e9-ef44-493c-9456-25e70ad84be6	2019-10-08 16:23:31.30946	t	\N	adde16c5-84a9-429e-8527-a4a954bd2546	28b37579-ad3e-48e0-9e0d-422ee2a7ced8	50a33200-9202-4483-8f72-4538eb3a0275	\N	\N
50320ee7-5285-427c-8c85-5827cb319b2f	2019-10-08 16:27:41.562744	t	\N	6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	e1377520-c3c2-4eaa-9253-c25f1fc9dc7d	7d5e899d-ef14-4396-9cce-e20dffac636e	\N	{}
3b50279f-1474-4b22-952b-2b7a151619ed	2019-10-08 16:31:04.62741	t	\N	6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	40e693e3-3871-44b8-899a-8f34d8735079	8eb20963-9dee-43a7-b084-5fffe7f635cd	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3}
849c5db8-ec26-44a1-9822-ed476dcbdb09	2019-10-08 16:52:09.294115	t	\N	adde16c5-84a9-429e-8527-a4a954bd2546	9cfe7788-7af6-4307-b098-d6bedeaeae90	6e3613a1-b132-46e6-b7a0-bac6c126011d	\N	\N
37bd9f8e-c38e-4eaa-a339-8d1e5b0a670b	2019-10-08 17:15:04.394153	t	\N	f1661738-0ef2-4eea-938d-92c70d913e98	60017371-f595-4f83-a0f8-19fa3e7a29ec	c28e1887-d366-4d85-9734-e8cb6ac71633	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673,705f4aa2-d1d0-4550-ba18-3ae328f57673}
83a4359e-dd71-4c1e-9c48-3451f59dc50a	2019-10-08 17:37:19.029515	t	\N	6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	1918cdbd-b8e0-4f20-aa15-af7a05bb49ee	7b933e82-cfcc-4a79-9eac-c5336cba8a2e	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3,eb27cc47-fd1b-455f-aae0-bb15db16fff3,705f4aa2-d1d0-4550-ba18-3ae328f57673,705f4aa2-d1d0-4550-ba18-3ae328f57673,705f4aa2-d1d0-4550-ba18-3ae328f57673,705f4aa2-d1d0-4550-ba18-3ae328f57673,705f4aa2-d1d0-4550-ba18-3ae328f57673,705f4aa2-d1d0-4550-ba18-3ae328f57673}
8776ff36-43f2-4a9a-9c02-d84258b3d610	2019-10-09 11:19:19.800051	t	\N	0114cf7f-2ae4-4c87-802d-905785ee80ea	10b78bf3-e330-4800-8c86-87da04c7392a	4be2425e-8ec0-422e-8fae-3a97df192734	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673,eb27cc47-fd1b-455f-aae0-bb15db16fff3}
21a0aa5b-d426-4f9b-9746-7096a0c1ac4b	2019-10-09 11:49:57.249275	t	\N	0114cf7f-2ae4-4c87-802d-905785ee80ea	027a54fd-d28e-44ec-a370-f3d7caaea1e3	eac88ee7-bb81-47a1-8528-df0c1bfb8c5e	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3}
172eb90b-283a-4d7d-90fb-d6a3fd8ec8ea	2019-10-09 12:29:18.325245	t	\N	0114cf7f-2ae4-4c87-802d-905785ee80ea	0a44fbb2-9702-4573-87d0-28002d31feb9	731dc4be-8e4b-45ea-b966-fb46c07e29b5	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673,705f4aa2-d1d0-4550-ba18-3ae328f57673}
22b7ecd7-c0d2-4ce3-8b1f-d3b32f923e9d	2019-10-08 14:24:13.618909	t	\N	adde16c5-84a9-429e-8527-a4a954bd2546	eb8d9cdc-9fc6-4e3e-82ad-e458f5bd25aa	790aad4f-e0f6-42e4-afac-b1a96a07da3b	\N	\N
e1e6bf85-7cee-48f8-bb2d-ff4d5d2365ce	2019-10-09 15:00:34.259957	t	\N	71133079-afeb-4193-80ec-ec97c61959c7	78cc9c64-2bb8-4f53-9582-3d868d4a2845	\N	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3}
57b2b82b-8bf6-47d1-a963-32577ee64221	2019-10-09 16:16:59.032487	t	\N	6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	a17341de-e6a8-4634-9e76-f3fcb4913f8e	\N	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673}
fd5ac993-6d1f-403a-b0ad-d3e8d9174973	2019-10-10 12:09:22.612912	t	\N	0114cf7f-2ae4-4c87-802d-905785ee80ea	8599b737-788f-42af-b502-f5ca3a4c9140	\N	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673}
571f2302-f7f4-4932-a886-80a77c1637c4	2019-10-10 12:11:03.565479	t	\N	0114cf7f-2ae4-4c87-802d-905785ee80ea	65944273-675d-42cb-bd53-abd5493a6692	\N	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673}
07b247ad-0145-4117-a574-2ae884d73694	2019-10-10 12:12:46.882494	t	\N	0114cf7f-2ae4-4c87-802d-905785ee80ea	bdbfab53-0647-46aa-89a6-08790fea00b7	\N	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673}
53db66ac-753e-4031-900a-0856b23711e5	2019-10-10 12:32:44.729709	t	\N	0114cf7f-2ae4-4c87-802d-905785ee80ea	b7a2608c-a625-47e5-8d08-df4dfb7d017d	\N	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3}
c970229d-1a23-4008-a450-9793fc46f4cb	2019-10-10 12:45:10.567118	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	182f6aee-e78f-4746-b51c-48ce77f7a24f	\N	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673}
dd9c3852-ee45-4512-b036-380e960bc5b8	2019-10-10 16:19:36.196759	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	758d9371-16f3-4d69-bc65-b222dbe6661e	a868b97f-c34f-4a1e-bdee-06dd57d49edb	\N	{4cbd562f-8191-49e7-81ae-e7c85447ac2c}
1272907b-182b-469d-998a-54dfeae42a52	2019-10-10 12:37:44.019681	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	deda128e-fece-497b-9a99-f882a6a6cb87	733aa274-1129-4e75-a5be-cf3f28b1cd5c	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673}
1bee3552-ec5e-4414-8940-b3991f50104c	2019-10-09 16:16:39.41517	t	\N	6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	7e89282d-012a-4722-b68d-92a0b3269157	a64bfef1-819d-4069-b380-9d2c0cf20e9c	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673}
0a36579a-d68f-4676-8698-48e07716af6d	2019-10-10 15:10:37.727834	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	e119a0aa-72a5-46ea-92cd-e9f954ef6cf1	\N	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3}
f1976b93-e83e-41f9-81fa-6bb927d661eb	2019-10-10 16:19:24.352146	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	af409fd3-d502-4b86-83d3-0fb54af25834	\N	\N	{4cbd562f-8191-49e7-81ae-e7c85447ac2c}
125d5548-1a8c-4dd3-9a5b-e0969811857a	2019-10-09 13:52:42.564963	t	\N	6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	9d758b34-c78f-4b09-bb5a-6dfd2c53c320	4819a812-1e82-4038-b400-0d9d59459e38	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3}
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.payment (payid, createdate, active, datemodify, slip, summary, datepayment, paystatusid, summarycheck) FROM stdin;
222b00ab-a3dd-4002-a842-e32583ff1434	2019-10-08 14:24:53.694214	t	\N	\N	\N	\N	1	\N
d8b7619f-1581-4590-b0c9-411ca1323692	2019-10-08 14:25:20.847625	t	\N	\N	\N	\N	1	\N
340e3ae5-586b-402e-9160-2c93b8292087	2019-10-08 15:18:49.572912	t	\N	\N	\N	\N	3	\N
ea9d1d0a-9caf-48b6-81a4-1b101dba946f	2019-10-08 15:18:49.572286	t	\N	\N	\N	\N	3	\N
28b37579-ad3e-48e0-9e0d-422ee2a7ced8	2019-10-08 16:23:31.275332	t	\N	\N	\N	\N	3	\N
e1377520-c3c2-4eaa-9253-c25f1fc9dc7d	2019-10-08 16:27:41.438565	t	\N	\N	\N	\N	3	\N
40e693e3-3871-44b8-899a-8f34d8735079	2019-10-08 16:31:04.505635	t	\N	\N	\N	\N	3	\N
9cfe7788-7af6-4307-b098-d6bedeaeae90	2019-10-08 16:52:09.258091	t	\N	\N	\N	\N	3	\N
60017371-f595-4f83-a0f8-19fa3e7a29ec	2019-10-08 17:15:04.364183	t	\N	\N	\N	\N	3	\N
1918cdbd-b8e0-4f20-aa15-af7a05bb49ee	2019-10-08 17:37:18.981106	t	\N	\N	\N	\N	3	\N
10b78bf3-e330-4800-8c86-87da04c7392a	2019-10-09 11:19:19.765907	t	\N	picture	1390	2019-10-01 02:26:03	3	\N
027a54fd-d28e-44ec-a370-f3d7caaea1e3	2019-10-09 11:49:57.196549	t	\N	picture	500	2019-10-09 13:08:33	3	\N
0a44fbb2-9702-4573-87d0-28002d31feb9	2019-10-09 12:29:18.295738	t	\N	picture	1200	2019-10-09 12:29:33	3	\N
eb8d9cdc-9fc6-4e3e-82ad-e458f5bd25aa	2019-10-08 14:24:13.474449	t	\N	\N	\N	\N	3	\N
78cc9c64-2bb8-4f53-9582-3d868d4a2845	2019-10-09 15:00:34.225941	t	\N	\N	\N	\N	1	\N
a17341de-e6a8-4634-9e76-f3fcb4913f8e	2019-10-09 16:16:58.987313	t	\N	\N	\N	\N	1	\N
8599b737-788f-42af-b502-f5ca3a4c9140	2019-10-10 12:09:22.442769	t	\N	\N	\N	\N	1	\N
65944273-675d-42cb-bd53-abd5493a6692	2019-10-10 12:11:03.529348	t	\N	\N	\N	\N	1	\N
bdbfab53-0647-46aa-89a6-08790fea00b7	2019-10-10 12:12:46.853612	t	\N	\N	\N	\N	1	\N
b7a2608c-a625-47e5-8d08-df4dfb7d017d	2019-10-10 12:32:44.632713	t	\N	\N	\N	\N	1	\N
182f6aee-e78f-4746-b51c-48ce77f7a24f	2019-10-10 12:45:10.538149	t	\N	\N	\N	\N	1	\N
deda128e-fece-497b-9a99-f882a6a6cb87	2019-10-10 12:37:43.961331	t	\N	picture	830	2019-10-10 12:39:58	3	\N
7e89282d-012a-4722-b68d-92a0b3269157	2019-10-09 16:16:39.371549	t	\N	picture	500	2019-09-30 12:16:33	3	\N
e119a0aa-72a5-46ea-92cd-e9f954ef6cf1	2019-10-10 15:10:37.698106	t	\N	\N	\N	\N	1	\N
af409fd3-d502-4b86-83d3-0fb54af25834	2019-10-10 16:19:24.2868	t	\N	\N	\N	\N	1	\N
07148724-b5d1-44c7-a904-450f651745f7	2019-10-09 13:40:54.878674	t	\N	picture	888	2019-10-09 13:51:10	3	\N
758d9371-16f3-4d69-bc65-b222dbe6661e	2019-10-10 16:19:36.16541	t	\N	picture	600	2019-10-10 17:25:17	3	\N
9d758b34-c78f-4b09-bb5a-6dfd2c53c320	2019-10-09 13:52:42.536167	t	\N	picture	89888	2019-10-09 13:51:10	3	\N
\.


--
-- Data for Name: paymentstatus; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.paymentstatus (paystatusid, createdate, active, datemodify, statusname) FROM stdin;
1	2019-10-08 14:13:49.991675	t	\N	รอชำระ
2	2019-10-08 14:13:50.112638	t	\N	รอตรวจสอบ
3	2019-10-08 14:13:50.161933	t	\N	ชำระเงินแล้ว
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.product (proid, createdate, active, datemodify, proname, prodetail, photo, sellerid, userid, timestart, timeend, category) FROM stdin;
ae8933b3-aff9-4a3e-bf13-01d2ba21e013	2019-10-08 14:19:13.805686	t	2019-10-08 14:19:13	ทุเรียนหมอนทอง	หอม กรอบ อร่อย	{picture-1570519153315.png}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	\N	\N	fruit
303729f1-67ea-4baf-94d8-b8081e8a9b4f	2019-10-08 14:19:44.610689	t	\N	ทุเรียนหมอนทอง	หอม กรอบ อร่อย	{picture-1570519153315.png}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	2019-10-08 14:19:44	2019-10-08 22:30:00	\N
7d2e5011-9f60-48c4-bc63-7f8c0e689935	2019-10-08 14:21:31.296194	t	2019-10-08 14:21:31	กล้อง CCTV	ปลอดภัย หายห่วง	{picture-1570519291283.jpg}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	\N	\N	electronic
0707e210-df30-4652-ab66-1baead7ae99b	2019-10-08 14:21:34.043389	t	2019-10-08 14:21:34	กล้อง CCTV	ปลอดภัย หายห่วง	{picture-1570519294036.jpg}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	\N	\N	electronic
2aaea643-6128-476a-9d49-ee382a80a824	2019-10-08 14:22:02.106393	t	2019-10-08 14:22:02	กล้อง CCTV	ปลอดภัย หายห่วง	{picture-1570519322092.jpg}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	\N	\N	electronic
4249fa47-87dd-4a06-a69e-307d00f78b7e	2019-10-08 14:22:19.40546	t	2019-10-08 14:22:19	กล้อง CCTV	ปลอดภัย หายห่วง	{picture-1570519339381.jpg}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	\N	\N	electronic
3450b950-3803-4881-a146-cf27dd81ccc6	2019-10-08 14:23:32.407496	t	\N	กล้อง CCTV	ปลอดภัย หายห่วง	{picture-1570519339381.jpg}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	2019-10-08 14:23:32	2019-10-08 21:30:17	\N
43426d51-2bf8-4928-92ba-6ae3aed58233	2019-10-08 16:18:47.425957	t	2019-10-08 16:18:47	เสื้อเบสบอล	เคลื่อนไหวคล่อง	{picture-1570526327157.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	\N	\N	clothes
b72c5c71-f7e1-44e8-aa40-5681b01f5a80	2019-10-08 16:22:13.688791	t	2019-10-08 16:22:13	เครื่องแบบนักเรียน	ใส่แล้วดูเด็กลง	{picture-1570526533642.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	\N	\N	clothes
39d714f4-a2c5-41bc-bd9c-f1678872c1b8	2019-10-08 16:22:51.465915	t	\N	เสื้อเบสบอล	เคลื่อนไหวคล่อง	{picture-1570526327157.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-08 16:22:51	2019-10-08 22:30:00	\N
f44d99fe-db38-4f7e-988e-176e443e7ee2	2019-10-08 16:42:35.32338	t	\N	เครื่องแบบนักเรียน	ใส่แล้วดูเด็กลง	{picture-1570526533642.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-08 16:42:35	2019-10-09 00:00:00	clothes
6dbefa8c-3b13-4892-abc6-ff553a56e26b	2019-10-08 17:01:23.278574	t	2019-10-08 17:01:23	แตงโม	หวาน อร่อย	{picture-1570528883249.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	\N	\N	fruit
d15bd560-6c01-46e5-9986-50a961c21285	2019-10-08 17:02:32.008297	t	2019-10-08 17:02:32	บ้านของเล่น	เสริมสร้างความรู้	{picture-1570528951933.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	\N	\N	kid
f8d21608-3e78-4c1b-aed6-bf0d6817b502	2019-10-08 17:04:17.735479	t	2019-10-08 17:04:17	กระเป๋าถือ	พกง่าย ใส่ของได้เยอะ	{picture-1570529057704.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	\N	\N	bag
14c3ac7b-edef-4497-be38-fff7de129bed	2019-10-08 17:06:34.722066	t	2019-10-08 17:06:34	ตู้เย็น	ประหยัดไฟ รักษาความสดได้ดีเยี่ยม	{picture-1570529194709.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	\N	\N	electronic
9c7131df-09eb-4485-840a-31537077d3b2	2019-10-08 17:07:49.986896	t	\N	แตงโม	หวาน อร่อย	{picture-1570528883249.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-08 17:07:49	2019-10-08 22:15:00	fruit
25fe2fd2-d6ba-4567-8943-c04cfaede4ef	2019-10-08 17:08:22.340789	t	\N	บ้านของเล่น	เสริมสร้างความรู้	{picture-1570528951933.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-08 17:08:22	2019-10-08 22:15:00	kid
d9bb5df7-969f-454e-b1f3-7857df53cc64	2019-10-08 17:08:48.443279	t	\N	กระเป๋าถือ	พกง่าย ใส่ของได้เยอะ	{picture-1570529057704.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-08 17:08:48	2019-10-08 23:15:00	bag
3870800e-0747-4226-9a76-3102de9f9911	2019-10-09 10:47:14.245242	t	\N	ทุเรียนหมอนทอง	หอม กรอบ อร่อย	{picture-1570519153315.png}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	2019-10-09 10:47:14	2019-10-09 18:00:00	\N
5d22486e-db77-45f3-a4e1-e5b66c670a4a	2019-10-09 11:15:16.788704	t	\N	บ้านของเล่น	เสริมสร้างความรู้	{picture-1570528951933.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-09 11:15:16	2019-10-09 18:20:00	kid
194bcc26-234a-490d-97d8-87bc711cdc88	2019-10-09 11:19:48.300571	t	\N	แตงโม	หวาน อร่อย	{picture-1570528883249.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-09 11:19:48	2019-10-09 21:30:00	fruit
ffb5565a-dc48-4fd3-b1a5-8c197fb10853	2019-10-10 10:40:07.154355	t	\N	กล้อง CCTV	ปลอดภัย หายห่วง	{picture-1570519339381.jpg}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	2019-10-10 10:40:07	2019-10-10 20:00:00	electronic
33f379b7-7c00-48d9-b0c0-8bff2e005f80	2019-10-10 10:40:55.879339	t	\N	ทุเรียนหมอนทอง	หอม กรอบ อร่อย	{picture-1570519153315.png}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	2019-10-10 10:40:55	2019-10-10 21:00:00	fruit
99005d89-759d-4ab8-a11e-0ccd386c5caa	2019-10-10 10:45:55.522376	t	\N	ตู้เย็น	ประหยัดไฟ รักษาความสดได้ดีเยี่ยม	{picture-1570529194709.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-10 10:45:55	2019-10-10 18:00:00	electronic
2100df1e-2c56-4627-9351-4dd1d552d693	2019-10-10 10:46:47.946084	t	\N	กระเป๋าถือ	พกง่าย ใส่ของได้เยอะ	{picture-1570529057704.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-10 10:46:47	2019-10-10 17:00:00	bag
fa0ad9af-ebbd-41d9-ab15-1088bceb5291	2019-10-10 10:47:55.959265	t	\N	เสื้อเบสบอล	เคลื่อนไหวคล่อง	{picture-1570526327157.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-10 10:47:55	2019-10-10 16:00:00	clothes
9f52df71-701e-4ac5-9a81-884ce5f2d21f	2019-10-10 10:49:21.037644	t	\N	บ้านของเล่น	เสริมสร้างความรู้	{picture-1570528951933.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-10 10:49:21	2019-10-10 21:00:00	kid
6a083bf1-54a5-4275-96d6-4d7cd7eb27a3	2019-10-08 17:07:27.249005	t	\N	ZZZZZZZZZZZZZZZZZZZZZZZZ	AAAAAAAAAAAAAAAAAAAAAA	{picture-1570529194709.jpg}	705f4aa2-d1d0-4550-ba18-3ae328f57673	\N	2019-10-08 17:07:27	2019-10-08 23:15:00	BBBBBBBBBBBBBBBBBBBBB
ac61d01f-356f-4e1b-838e-0e44d6769d5f	2019-10-10 11:14:07.62808	t	2019-10-10 11:14:07	ตัวต่อเด็กเล่น	เสริมสร้างความรู้ให้เด็กน้อย	{picture-1570693083043.jpg}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	\N	\N	kid
c4e9ddf2-b951-4095-8ff6-7b4264c9d978	2019-10-10 15:25:26.264602	t	2019-10-10 15:25:26	ชุดสูท	ดูดี มีระดับ	{picture-1570695926234.jpg}	35af0d28-57f5-4eae-8075-513921404b00	\N	\N	\N	clothes
e29c982a-bade-4a88-95d9-15f9637f19ca	2019-10-10 11:25:02.800916	t	2019-10-10 11:25:02	เสื้อโค้ตผู้ชาย	เนื้อผ้าคุณภาพ อบอุ่นยามหน้าหนาว	{picture-1570693376945.jpg}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	\N	\N	clothes
71439d4f-35be-47aa-9eb1-7f846fab4ed2	2019-10-08 14:21:21.132454	t	2019-10-08 14:21:21	กล้อง CCTV	ปลอดภัย หายห่วง	{picture-1570519280921.jpg}	eb27cc47-fd1b-455f-aae0-bb15db16fff3	\N	\N	\N	electronic
4f1c32ae-fea6-40e8-b174-0bb9cc2c72b1	2019-10-10 15:28:08.674204	t	\N	ชุดสูท	ดูดี มีระดับ	{picture-1570695926234.jpg}	35af0d28-57f5-4eae-8075-513921404b00	\N	2019-10-10 15:28:08	2019-10-10 21:40:00	clothes
a73611cc-8207-46cb-afa3-178ad4223b4b	2019-10-10 15:37:36.182237	t	2019-10-10 15:37:36	ส้ม	ส้มคัดคุณภาพ	{picture-1570696656146.jpg}	4cbd562f-8191-49e7-81ae-e7c85447ac2c	\N	\N	\N	fruit
e8c3e5f5-81f2-45e5-b6ca-11eaf254500b	2019-10-10 15:40:34.573321	t	2019-10-10 15:40:34	กระเป๋าสะพายข้าง	พกพาสะดวก 	{picture-1570696834539.jpg}	4cbd562f-8191-49e7-81ae-e7c85447ac2c	\N	\N	\N	bag
e2078ad4-40a0-452c-afdd-36fd6227a6ff	2019-10-10 15:41:23.728537	t	\N	ส้ม	ส้มคัดคุณภาพ	{picture-1570696656146.jpg}	4cbd562f-8191-49e7-81ae-e7c85447ac2c	\N	2019-10-10 15:41:23	2019-10-10 22:00:00	fruit
d92ed07c-a262-4294-a472-74f58c3456ce	2019-10-10 16:18:39.361533	t	\N	กระเป๋าสะพายข้าง	พกพาสะดวก 	{picture-1570696834539.jpg}	4cbd562f-8191-49e7-81ae-e7c85447ac2c	\N	2019-10-10 16:18:39	2019-10-11 01:20:00	bag
\.


--
-- Data for Name: productoption; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.productoption (proopid, createdate, active, datemodify, price, includingvat, optionvalue, proid, types, totalproduct, sku) FROM stdin;
4b391e19-3c74-4209-9e44-c8e971b23634	2019-10-08 14:19:13.881583	t	2019-10-08 14:19:13	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"A\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"15 kg\\"}"}	ae8933b3-aff9-4a3e-bf13-01d2ba21e013	order	\N	F001
25b5e885-5a61-49d7-93cd-1dd069406ff1	2019-10-08 14:19:13.804802	t	2019-10-08 14:19:13	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}"}	ae8933b3-aff9-4a3e-bf13-01d2ba21e013	order	\N	F002
3a94d462-a31b-43cf-9e2e-caff60887e3e	2019-10-08 14:19:13.885466	t	2019-10-08 14:19:13	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"10 kg\\"}"}	ae8933b3-aff9-4a3e-bf13-01d2ba21e013	order	\N	F003
60595e64-28e7-440a-b442-7369bbf84b5a	2019-10-08 14:19:44.656491	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"A\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"15 kg\\"}"}	303729f1-67ea-4baf-94d8-b8081e8a9b4f	preorder	3	F001
6ef43b86-7862-4a62-99f3-d5eb49a170f4	2019-10-08 14:19:44.661685	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}"}	303729f1-67ea-4baf-94d8-b8081e8a9b4f	preorder	6	F002
ea297306-4cd1-4277-8b1b-717ee7544925	2019-10-08 14:19:44.663667	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"10 kg\\"}"}	303729f1-67ea-4baf-94d8-b8081e8a9b4f	preorder	8	F003
bc380b5e-8e70-4d3b-b6f7-82ff9e267f13	2019-10-08 14:21:31.295506	t	2019-10-08 14:21:31	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"5 ตัว\\"}"}	7d2e5011-9f60-48c4-bc63-7f8c0e689935	order	\N	E002
41338e1b-9e1d-4010-a91b-423392dbb712	2019-10-08 14:22:19.4453	t	2019-10-08 14:22:19	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"1 ตัว\\"}"}	4249fa47-87dd-4a06-a69e-307d00f78b7e	order	\N	EE001
061cb998-208b-45e0-ac35-0278e7b9a9eb	2019-10-08 14:22:19.402946	t	2019-10-08 14:22:19	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"5 ตัว\\"}"}	4249fa47-87dd-4a06-a69e-307d00f78b7e	order	\N	EE002
e3d80bdb-a7d5-4b68-a843-b1fc01f5ee36	2019-10-08 14:23:32.569148	t	\N	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"1 ตัว\\"}"}	3450b950-3803-4881-a146-cf27dd81ccc6	preorder	12	EE001
efc0047a-8ba3-4c53-9b14-47abe1e0488d	2019-10-08 14:23:32.574301	t	\N	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"5 ตัว\\"}"}	3450b950-3803-4881-a146-cf27dd81ccc6	preorder	11	EE002
08b9120a-4a04-48c7-89bb-1a48e1fcf6a6	2019-10-08 16:18:47.546093	t	2019-10-08 16:18:47	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"S\\"}"}	43426d51-2bf8-4928-92ba-6ae3aed58233	order	\N	S001
28fe4afc-d7ba-40db-923e-4946f202c3e4	2019-10-08 16:18:47.425536	t	2019-10-08 16:18:47	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"M\\"}"}	43426d51-2bf8-4928-92ba-6ae3aed58233	order	\N	S002
9f00df72-05d0-44da-bc1e-8c50c7c52238	2019-10-08 16:18:47.546762	t	2019-10-08 16:18:47	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}"}	43426d51-2bf8-4928-92ba-6ae3aed58233	order	\N	S003
e7cb80d5-99ac-4631-8e38-6a676bfcef7a	2019-10-08 16:22:13.72287	t	2019-10-08 16:22:13	2300	150.469999999999999	{"{\\"name\\":\\"ประเภท\\",\\"value\\":\\"ชุดนักเรียน\\"}","{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}"}	b72c5c71-f7e1-44e8-aa40-5681b01f5a80	order	\N	STD001
76757920-6c46-4dad-a51b-0c1b4424f0a7	2019-10-08 16:22:13.687162	t	2019-10-08 16:22:13	2300	150.469999999999999	{"{\\"name\\":\\"ประเภท\\",\\"value\\":\\"ชุด รด\\"}","{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}"}	b72c5c71-f7e1-44e8-aa40-5681b01f5a80	order	\N	STD002
0caf9fe6-220a-4adc-b75a-618c18221056	2019-10-08 16:22:51.588661	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"S\\"}"}	39d714f4-a2c5-41bc-bd9c-f1678872c1b8	preorder	100	S001
79f3ca87-f056-44fc-9335-45db277f98de	2019-10-08 16:22:51.592815	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"M\\"}"}	39d714f4-a2c5-41bc-bd9c-f1678872c1b8	preorder	150	S002
92cab296-1a41-4e94-b500-7145e91c5b73	2019-10-08 16:22:51.593246	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}"}	39d714f4-a2c5-41bc-bd9c-f1678872c1b8	preorder	90	S003
df8bb2f9-98ec-41ce-ba38-3106fc3c291d	2019-10-08 16:42:35.351622	t	\N	2300	150.469999999999999	{"{\\"name\\":\\"ประเภท\\",\\"value\\":\\"ชุดนักเรียน\\"}","{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}"}	f44d99fe-db38-4f7e-988e-176e443e7ee2	preorder	150	STD001
245b59b9-09b8-40d2-a885-3ce640eaf162	2019-10-08 16:42:35.356847	t	\N	2300	150.469999999999999	{"{\\"name\\":\\"ประเภท\\",\\"value\\":\\"ชุด รด\\"}","{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}"}	f44d99fe-db38-4f7e-988e-176e443e7ee2	preorder	200	STD002
cc86a609-336a-4e10-8d69-c469cbb8aa89	2019-10-08 17:01:23.310944	t	2019-10-08 17:01:23	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"1.5 kg\\"}"}	6dbefa8c-3b13-4892-abc6-ff553a56e26b	order	\N	WM001
45b2fda9-ce8a-4570-8b14-dc316f5592a8	2019-10-08 17:01:23.278253	t	2019-10-08 17:01:23	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"5 kg\\"}"}	6dbefa8c-3b13-4892-abc6-ff553a56e26b	order	\N	WM002
797d003c-5bc1-4ce2-82e2-55320a634f2a	2019-10-08 17:02:32.036904	t	2019-10-08 17:02:32	890	58.2199999999999989	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"เล็ก\\"}"}	d15bd560-6c01-46e5-9986-50a961c21285	order	\N	H001
9cc89cea-20eb-4d3e-be4f-3922ad550e84	2019-10-08 17:02:32.007845	t	2019-10-08 17:02:32	1500	98.1299999999999955	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"ใหญ่\\"}"}	d15bd560-6c01-46e5-9986-50a961c21285	order	\N	H002
22ad1d90-4a78-466c-b2ec-16616e8f8a50	2019-10-08 17:04:17.812305	t	2019-10-08 17:04:17	780	51.0300000000000011	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ขาว-เทา\\"}"}	f8d21608-3e78-4c1b-aed6-bf0d6817b502	order	\N	HB001
43835e93-fd8c-49dd-876c-cd0de13eef26	2019-10-08 17:04:17.735237	t	2019-10-08 17:04:17	890	58.2199999999999989	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ-แดง\\"}"}	f8d21608-3e78-4c1b-aed6-bf0d6817b502	order	\N	HB002
80c3cf78-529e-49a5-9ca4-cbcd892e9f69	2019-10-08 17:06:34.766394	t	2019-10-08 17:06:34	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"5 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	14c3ac7b-edef-4497-be38-fff7de129bed	order	\N	CE001
be308ac7-4ad7-4e73-9b77-26d1577eb81f	2019-10-08 17:06:34.721861	t	2019-10-08 17:06:34	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"แดง\\"}"}	14c3ac7b-edef-4497-be38-fff7de129bed	order	\N	CE002
b9f099f1-1764-4762-ada4-280fb58045ee	2019-10-08 17:06:34.766649	t	2019-10-08 17:06:34	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	14c3ac7b-edef-4497-be38-fff7de129bed	order	\N	CE003
ff7d76eb-82ec-4823-88c6-11e106566aff	2019-10-08 17:07:27.290894	t	\N	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"แดง\\"}"}	6a083bf1-54a5-4275-96d6-4d7cd7eb27a3	preorder	50	CE002
938ec6e1-7bee-4a65-815c-949c1758a7b6	2019-10-08 17:07:50.113194	t	\N	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"1.5 kg\\"}"}	9c7131df-09eb-4485-840a-31537077d3b2	preorder	90	WM001
64d39e3b-ccc7-4dce-b1b6-bd68dfa39b6e	2019-10-08 17:07:50.118014	t	\N	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"5 kg\\"}"}	9c7131df-09eb-4485-840a-31537077d3b2	preorder	100	WM002
2f39ecf7-dcec-4b7b-9519-e143219d5c79	2019-10-08 17:08:22.382028	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"เล็ก\\"}"}	25fe2fd2-d6ba-4567-8943-c04cfaede4ef	preorder	50	H001
66c43745-7e22-4d51-8b73-f05bc6184ea3	2019-10-08 17:08:22.382761	t	\N	1500	98.1299999999999955	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"ใหญ่\\"}"}	25fe2fd2-d6ba-4567-8943-c04cfaede4ef	preorder	100	H002
7fe46d0c-e842-404f-8fe6-1d91e4d57eff	2019-10-08 17:08:48.56083	t	\N	780	51.0300000000000011	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ขาว-เทา\\"}"}	d9bb5df7-969f-454e-b1f3-7857df53cc64	preorder	50	HB001
95a606a7-4e4b-4032-aab2-508426449e48	2019-10-08 17:07:27.291091	t	\N	9999999999999	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	6a083bf1-54a5-4275-96d6-4d7cd7eb27a3	preorder	90	CE003
7b966601-afa0-4723-906f-cd0c7b11e31f	2019-10-08 14:21:21.168195	t	2019-10-08 14:21:21	500	32.7100000000000009	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"1 ตัว\\"}"}	71439d4f-35be-47aa-9eb1-7f846fab4ed2	order	\N	E001
d6488c3e-7e19-4019-81be-7f71dffa4d25	2019-10-08 17:08:48.566561	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ-แดง\\"}"}	d9bb5df7-969f-454e-b1f3-7857df53cc64	preorder	50	HB002
1e456eed-7a13-49cd-bd18-d8326e0ecfae	2019-10-09 10:47:14.37648	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"A\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"15 kg\\"}"}	3870800e-0747-4226-9a76-3102de9f9911	preorder	90	F001
7c91f21b-326b-4a7b-a0bb-492586eca7b9	2019-10-09 10:47:14.382517	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}"}	3870800e-0747-4226-9a76-3102de9f9911	preorder	50	F002
510619d6-fb59-43aa-bf61-e0e5a3732f83	2019-10-09 10:47:14.38303	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"10 kg\\"}"}	3870800e-0747-4226-9a76-3102de9f9911	preorder	70	F003
aa814f5f-8af5-4c53-943d-a0ab54e018c6	2019-10-09 11:15:16.821711	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"เล็ก\\"}"}	5d22486e-db77-45f3-a4e1-e5b66c670a4a	preorder	50	H001
bb5bb540-9db1-4ed1-a01e-c7365ddb7303	2019-10-09 11:15:16.826902	t	\N	1500	98.1299999999999955	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"ใหญ่\\"}"}	5d22486e-db77-45f3-a4e1-e5b66c670a4a	preorder	70	H002
3eba6edb-ec04-480b-8dea-dcc5453fe0f4	2019-10-09 11:19:48.356922	t	\N	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"1.5 kg\\"}"}	194bcc26-234a-490d-97d8-87bc711cdc88	preorder	120	WM001
53d1d3bc-a257-4624-a9a7-b479b9553b1f	2019-10-09 11:19:48.357165	t	\N	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"5 kg\\"}"}	194bcc26-234a-490d-97d8-87bc711cdc88	preorder	100	WM002
4f4c0b31-15f9-48dd-941f-694bcdeaac1d	2019-10-10 10:40:07.317543	t	\N	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"1 ตัว\\"}"}	ffb5565a-dc48-4fd3-b1a5-8c197fb10853	preorder	50	EE001
c75eccb3-5230-4278-accf-6e4cef60a27d	2019-10-10 10:40:07.325606	t	\N	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"5 ตัว\\"}"}	ffb5565a-dc48-4fd3-b1a5-8c197fb10853	preorder	100	EE002
1152c7cd-4d9b-4d7a-80e1-5ab14da8d4e0	2019-10-10 10:40:55.949534	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"A\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"15 kg\\"}"}	33f379b7-7c00-48d9-b0c0-8bff2e005f80	preorder	50	F001
71f64bfc-40af-4d81-bb61-42f3675d9284	2019-10-10 10:40:55.961305	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}"}	33f379b7-7c00-48d9-b0c0-8bff2e005f80	preorder	70	F002
4596ab0d-1e8b-47ec-a88e-32977cb1fc44	2019-10-10 10:40:55.962107	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"10 kg\\"}"}	33f379b7-7c00-48d9-b0c0-8bff2e005f80	preorder	47	F003
b6b7dadb-d667-4a2f-9f4a-12b5f1dfc5fe	2019-10-10 10:45:55.553702	t	\N	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"5 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	99005d89-759d-4ab8-a11e-0ccd386c5caa	preorder	50	CE001
beb76969-5dde-45b7-893f-c9d69d545a56	2019-10-10 10:45:55.55708	t	\N	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"แดง\\"}"}	99005d89-759d-4ab8-a11e-0ccd386c5caa	preorder	50	CE002
f7a051f0-40e3-4e06-b690-7d950a6f6ae9	2019-10-10 10:45:55.557767	t	\N	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	99005d89-759d-4ab8-a11e-0ccd386c5caa	preorder	70	CE003
01065ea7-8823-4048-85cf-aa30fe119538	2019-10-10 10:46:47.979411	t	\N	780	51.0300000000000011	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ขาว-เทา\\"}"}	2100df1e-2c56-4627-9351-4dd1d552d693	preorder	20	HB001
2ab9b897-ef4f-4676-a2d1-4bba7b560c7e	2019-10-10 10:46:47.983063	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ-แดง\\"}"}	2100df1e-2c56-4627-9351-4dd1d552d693	preorder	40	HB002
d46dfdb2-9e5a-44e4-9f7f-12ceb69fea57	2019-10-10 10:47:55.997396	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"S\\"}"}	fa0ad9af-ebbd-41d9-ab15-1088bceb5291	preorder	80	S001
b4ebcc48-11de-4473-a030-8e0b36ea99bb	2019-10-10 10:47:56.000608	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"M\\"}"}	fa0ad9af-ebbd-41d9-ab15-1088bceb5291	preorder	80	S002
b413f0fc-0eb6-4b7b-8289-1d8ca29bc05c	2019-10-10 10:47:56.000953	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}"}	fa0ad9af-ebbd-41d9-ab15-1088bceb5291	preorder	80	S003
764638f1-280a-4ce5-b908-cc92f0169560	2019-10-10 10:49:21.111392	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"เล็ก\\"}"}	9f52df71-701e-4ac5-9a81-884ce5f2d21f	preorder	50	H001
e2449b65-152d-4b3b-a626-f2afdb54f848	2019-10-10 10:49:21.114874	t	\N	1500	98.1299999999999955	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"ใหญ่\\"}"}	9f52df71-701e-4ac5-9a81-884ce5f2d21f	preorder	60	H002
c05c0b24-827d-424e-8e2d-7981dfda8632	2019-10-10 15:28:08.795901	t	\N	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"black\\"}"}	4f1c32ae-fea6-40e8-b174-0bb9cc2c72b1	preorder	20	SUIT001
74e552b6-c654-4722-9a43-7b582f3befa0	2019-10-08 17:07:27.284862	t	\N	9999999999999	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"5 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	6a083bf1-54a5-4275-96d6-4d7cd7eb27a3	preorder	30	CE001
8cc5e66a-912f-410e-9e87-63bfcd4307e5	2019-10-10 11:25:02.800041	t	2019-10-10 11:25:02	2505	163.550000000000011	{"{\\"name\\":\\"ัสี\\",\\"value\\":\\"ขาว\\"}","{\\"name\\":\\"ไซต์\\",\\"value\\":\\"L\\"}"}	e29c982a-bade-4a88-95d9-15f9637f19ca	order	\N	C002
13eb15cd-f2e9-459a-b92f-85f113a0479b	2019-10-10 11:25:02.834017	t	2019-10-10 11:25:02	1505	98.1299999999999955	{"{\\"name\\":\\"ัสี\\",\\"value\\":\\"น้ำตาล\\"}","{\\"name\\":\\"ไซต์\\",\\"value\\":\\"XL\\"}"}	e29c982a-bade-4a88-95d9-15f9637f19ca	order	\N	C001
7fc5cc27-14a8-4788-bb6f-28cd71636293	2019-10-10 15:25:26.483692	t	2019-10-10 15:25:26	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"black\\"}"}	c4e9ddf2-b951-4095-8ff6-7b4264c9d978	order	\N	SUIT001
4b7b2fac-46b0-4fd9-b85d-036d1d80ce08	2019-10-10 15:25:26.26382	t	2019-10-10 15:25:26	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"white\\"}"}	c4e9ddf2-b951-4095-8ff6-7b4264c9d978	order	\N	SUIT002
1eb1668d-f22d-4ee9-82c7-34122947b1be	2019-10-10 15:25:26.491942	t	2019-10-10 15:25:26	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"black\\"}"}	c4e9ddf2-b951-4095-8ff6-7b4264c9d978	order	\N	SUIT003
a1c09ad7-39a0-4a14-915b-e94dd6dc0ae8	2019-10-10 11:14:07.680946	t	2019-10-10 11:14:07	500	19.629999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"เล็ก\\"}"}	ac61d01f-356f-4e1b-838e-0e44d6769d5f	order	\N	KID003
2cea70d5-2deb-42e2-9ac2-74b36dc26038	2019-10-10 11:14:07.676945	t	2019-10-10 11:14:07	300	19.629999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"ใหญ่\\"}"}	ac61d01f-356f-4e1b-838e-0e44d6769d5f	order	\N	KID001
9915228c-bde9-47ce-9b1d-7bf09dc26963	2019-10-10 11:14:07.626987	t	2019-10-10 11:14:07	400	19.629999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"กลาง\\"}"}	ac61d01f-356f-4e1b-838e-0e44d6769d5f	order	\N	KID002
5e587e2b-9c96-4c93-a8af-15a8c7b50d56	2019-10-10 15:28:08.804316	t	\N	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"white\\"}"}	4f1c32ae-fea6-40e8-b174-0bb9cc2c72b1	preorder	30	SUIT002
952c011a-a16d-4add-948c-91f25ce1d5cc	2019-10-10 15:28:08.805084	t	\N	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"black\\"}"}	4f1c32ae-fea6-40e8-b174-0bb9cc2c72b1	preorder	30	SUIT003
dddebc28-b306-4e3a-a0cf-79d977e9b6a6	2019-10-10 15:37:36.245554	t	2019-10-10 15:37:36	220	14.3900000000000006	{"{\\"name\\":\\"สายพันธุ์\\",\\"value\\":\\"สายน้ำผึ้ง\\"}"}	a73611cc-8207-46cb-afa3-178ad4223b4b	order	\N	FR-ORG-001
966811bf-9da8-4de4-9314-c4cacd1ffd9d	2019-10-10 15:37:36.181285	t	2019-10-10 15:37:36	220	14.3900000000000006	{"{\\"name\\":\\"สายพันธุ์\\",\\"value\\":\\"เขียวหวาน\\"}"}	a73611cc-8207-46cb-afa3-178ad4223b4b	order	\N	FR-ORG-002
eac65010-c64d-4fb9-a0a5-c60d70288400	2019-10-10 15:40:34.601105	t	2019-10-10 15:40:34	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"เทา\\"}"}	e8c3e5f5-81f2-45e5-b6ca-11eaf254500b	order	\N	BAG-SIDE-001
08a925fa-62a3-4090-b406-64166305c051	2019-10-10 15:40:34.573009	t	2019-10-10 15:40:34	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	e8c3e5f5-81f2-45e5-b6ca-11eaf254500b	order	\N	BAG-SIDE-002
faf0cb5a-92ec-4189-a749-b1daf24cd4cc	2019-10-10 15:40:34.603605	t	2019-10-10 15:40:34	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"แดง\\"}"}	e8c3e5f5-81f2-45e5-b6ca-11eaf254500b	order	\N	BAG-SIDE-003
9cffea1b-3292-4007-bf3d-225333ace1c9	2019-10-10 15:41:23.764949	t	\N	220	14.3900000000000006	{"{\\"name\\":\\"สายพันธุ์\\",\\"value\\":\\"สายน้ำผึ้ง\\"}"}	e2078ad4-40a0-452c-afdd-36fd6227a6ff	preorder	39	FR-ORG-001
154a260f-864d-4d89-a9ea-4f073b99a800	2019-10-10 15:41:23.768542	t	\N	220	14.3900000000000006	{"{\\"name\\":\\"สายพันธุ์\\",\\"value\\":\\"เขียวหวาน\\"}"}	e2078ad4-40a0-452c-afdd-36fd6227a6ff	preorder	54	FR-ORG-002
5eb8060c-41bf-4dd8-8bbb-ad0797e34074	2019-10-10 16:18:39.392872	t	\N	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"เทา\\"}"}	d92ed07c-a262-4294-a472-74f58c3456ce	preorder	31	BAG-SIDE-001
8d13b852-5f9c-4dde-b48c-94919e8d4581	2019-10-10 16:18:39.397176	t	\N	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"แดง\\"}"}	d92ed07c-a262-4294-a472-74f58c3456ce	preorder	48	BAG-SIDE-003
d8526baa-38b7-4138-96c4-f498759a4e67	2019-10-10 16:18:39.397412	t	\N	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	d92ed07c-a262-4294-a472-74f58c3456ce	preorder	31	BAG-SIDE-002
\.


--
-- Data for Name: promptpay; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.promptpay (promptpayid, createdate, active, datemodify, promptpayname, promptpaynumber) FROM stdin;
54df9d83-c233-41ce-9fcf-5b35c704b7d8	2019-10-08 16:16:35	t	2019-10-10 12:54:51	\N	\N
7761e4bc-1498-40da-8069-f2c008590f3b	2019-10-08 14:15:04	t	2019-10-10 14:34:17	\N	\N
7c260b33-8ca8-4b40-8c1d-56979bc990c7	2019-10-10 15:08:56	t	2019-10-10 15:08:56		
725bfb49-6e7a-4ce4-b6b9-4465263854d4	2019-10-10 15:33:10	t	2019-10-10 15:33:10		
\.


--
-- Data for Name: receipt; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.receipt (receiptid, createdate, active, datemodify, orderid) FROM stdin;
\.


--
-- Data for Name: seller; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.seller (sellerid, createdate, active, datemodify, sellername, address, subdistrict, district, zipcode, province, phonenumber, email, sellerpassword, taxid, photo, bankid, promptpayid) FROM stdin;
705f4aa2-d1d0-4550-ba18-3ae328f57673	2019-10-08 16:16:35.723479	t	2019-10-10 12:54:51	\N	\N	\N	\N	\N	\N	\N	\N	$2b$08$a3MHs8Kl57Nr4neWAEdPPunfMZlilfZTUsVFOPB1Lb.j689mxYOHW	456451285252	picture-1570526234641.jpg	8d47a16b-1244-4e81-a022-eb47526dd030	54df9d83-c233-41ce-9fcf-5b35c704b7d8
35af0d28-57f5-4eae-8075-513921404b00	2019-10-10 15:08:56.791801	t	2019-10-10 15:08:56	beabea	100 หมู่ 13	กุดน้ำใส	จัตุรัส	36130	ชัยภูมิ	0926633322	beabea@gmail.com	$2b$08$h2Gp5seJ/Y5XRiL0d3gGXuUkXdCEkg4bcPKaR7KI2P5Xr2JVucENG	9638528452	picture-1570694936540.jpg	f6896d33-652f-40c0-bb2b-c78076ea8ce5	7c260b33-8ca8-4b40-8c1d-56979bc990c7
4cbd562f-8191-49e7-81ae-e7c85447ac2c	2019-10-10 15:33:10.504356	t	2019-10-10 15:33:10	Danik	101 พหลโยธิน 25	จตุจักร	จตุจักร	10900	กรุงเทพฯ	0957415253	daniel@gmail.com	$2b$08$z5td8GuZEPefDfw5wgtDt.tW88YBWc6Me09PR6K2Ius/2GizdcO0q	96352852566	picture-1570696390238.jpg	c596bb5f-76c2-4dfa-9af5-dc495f916e0c	725bfb49-6e7a-4ce4-b6b9-4465263854d4
eb27cc47-fd1b-455f-aae0-bb15db16fff3	2019-10-08 14:15:04.814668	t	2019-10-10 14:34:17	\N	\N	\N	\N	\N	\N	\N	\N	$2b$08$0XJ8pPLGhjBPEUBzjcfkKu6eO354zXyTIrnrgH3YtWWKUckAguD9C	895628945612	picture-1570518904495.jpg	604dc9b0-f9d4-4329-8873-e359bdede88a	7761e4bc-1498-40da-8069-f2c008590f3b
\.


--
-- Data for Name: shipping; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.shipping (shipid, createdate, active, datemodify, shiptrackno, shipstatusid) FROM stdin;
6e3613a1-b132-46e6-b7a0-bac6c126011d	2019-10-09 12:39:10.0146	t	\N	EW6558585TH	3
731dc4be-8e4b-45ea-b966-fb46c07e29b5	2019-10-09 12:40:47.204285	t	\N	RE6558585TH	3
4be2425e-8ec0-422e-8fae-3a97df192734	2019-10-09 12:40:06.503999	t	\N	RA685885TH	3
7b933e82-cfcc-4a79-9eac-c5336cba8a2e	2019-10-09 12:39:47.538956	t	\N	RP085852TH	3
7d5e899d-ef14-4396-9cce-e20dffac636e	2019-10-09 12:38:34.35649	t	\N	\N	4
790aad4f-e0f6-42e4-afac-b1a96a07da3b	2019-10-09 12:41:04.823523	t	\N	RR954852TH	3
8f01c290-0264-41bc-b34d-a459cfd122d6	2019-10-09 12:37:46.36655	t	\N	EU085852TH	3
50a33200-9202-4483-8f72-4538eb3a0275	2019-10-09 12:38:03.437035	t	\N	ED089572TH	3
c28e1887-d366-4d85-9734-e8cb6ac71633	2019-10-09 12:39:26.489808	t	\N	ES6553215TH	3
eac88ee7-bb81-47a1-8528-df0c1bfb8c5e	2019-10-09 12:40:28.666469	t	\N	EP088552TH	3
8eb20963-9dee-43a7-b084-5fffe7f635cd	2019-10-09 12:38:52.134396	t	\N	WE56265564TH	3
6c5c0316-4bcb-4de7-9a2a-bedcfb78f897	2019-10-10 12:46:55.902803	t	\N	\N	1
a64bfef1-819d-4069-b380-9d2c0cf20e9c	2019-10-10 14:48:26.973621	t	\N	\N	1
0ed7b1c5-859c-4143-a52a-dc84c97a1f08	2019-10-09 12:37:28.60992	t	\N	KLABSDKJBASD-ASKJLDBKASJD	4
733aa274-1129-4e75-a5be-cf3f28b1cd5c	2019-10-10 14:23:46.576787	t	\N	\N	4
a2b9d7b6-ba53-47af-9cf8-7d62a9e49045	2019-10-09 12:35:47.221742	t	\N	ABCDEFGHIJ	1
594ccb38-7f4a-4630-a800-f79169fe4ca4	2019-10-10 16:36:24.988515	t	\N	\N	1
4819a812-1e82-4038-b400-0d9d59459e38	2019-10-10 16:37:18.304252	t	\N	\N	1
a868b97f-c34f-4a1e-bdee-06dd57d49edb	2019-10-10 16:36:53.109333	t	\N	RE258852963TH	3
\.


--
-- Data for Name: shippingstatus; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.shippingstatus (shipstatusid, shippingstatusname, createdate, active, datemodify) FROM stdin;
1	สินค้ายังไม่ได้ทำการจัดส่ง	2019-10-08 14:13:50.21124	t	\N
2	รอตรวจสอบ การส่งสินค้า	2019-10-08 14:13:50.246282	t	\N
3	สินค้ายังทำการจัดส่งเรียบร้อยเเล้ว	2019-10-08 14:13:50.270975	t	\N
4	ยืนยันการจัดส่งเรียบร้อยเเล้ว	2019-10-08 16:18:43.073262	t	\N
\.


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
-- Name: member member_email_key; Type: CONSTRAINT; Schema: public; Owner: aom
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_email_key UNIQUE (email);


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

