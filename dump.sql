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
    sku character varying(60),
    totalproduct integer,
    CONSTRAINT productoption_price_check CHECK ((price > (0)::double precision)),
    CONSTRAINT productoption_totalproduct_check CHECK ((totalproduct > 0))
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
c596bb5f-76c2-4dfa-9af5-dc495f916e0c	2019-10-10 15:33:10	t	2019-10-10 15:33:10	Daniel K	TMB	963525155252
af93de31-2a81-4e42-8345-340f87a73973	2019-10-11 16:26:54	t	2019-10-11 16:26:54	threestar	KBANK	0852852
ce0cddd6-a630-4d61-b46e-efdc09535d11	2019-10-11 16:33:08	f	2019-10-11 16:33:08	SCB	apisitprompha	646465668
b993e44e-631e-43ee-b48d-e2cbfd26b2c5	2019-10-11 16:40:53	t	2019-10-11 16:40:53			
3155fbb2-85d1-4b22-9cde-2e157fc7c568	2019-10-11 16:53:48	t	2019-10-11 16:53:48	Daniel K	TMB	5265265245
f6896d33-652f-40c0-bb2b-c78076ea8ce5	2019-10-10 15:08:56	t	2019-10-11 17:07:05	Bea jin	SCB	25962348512
8abb4d69-cf1d-4860-8c23-e89d870ed69d	2019-10-11 17:09:04	t	2019-10-11 17:09:04			
58d47651-3776-4689-8749-66e475869123	2019-10-11 17:09:47	t	2019-10-11 17:09:47	SCB	apisitprompha	646465668
c611133c-48ee-473a-addb-a67d572fe7bc	2019-10-11 17:12:05	f	2019-10-11 17:12:05	SCB	apisitprompha	646465668
7f3c9636-c786-4197-a5e7-679c45042706	2019-10-11 17:13:29	f	2019-10-11 17:13:29	SCB	apisitprompha	646465668
a6e0217b-9c26-42c8-bb4a-ee3b758fa810	2019-10-11 17:14:48	f	2019-10-11 17:14:48			
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
1f5b966d-b36f-480f-b494-21c784e6f2eb	2019-10-11 10:56:34	t	2019-10-11 10:56:34	apisit	prompha	man	2016-06-06	BKK	big	bigger	Bankok	30000	\N	0933347977	$2b$08$GdUiDFOjtXje6u6buWQ8G.zHnY.X3IoIkX6YX2IF7fVKZMQsqYk.y	ooo@gmail.com
e8ef5c77-434d-467e-9146-06f3f8fb80ae	2019-10-11 11:21:37	t	2019-10-11 11:21:37	ภัทรจาริน	กระสินธุ์หอม	หญิง	2019-10-16	\N	\N	\N	\N	\N	\N	\N	$2b$08$x7Lg0/UtES/Rt4CfUTZiFOvlHhPi3osE5.xrBIMF6Ns9mqlziHCpy	d@gmail.com
f1661738-0ef2-4eea-938d-92c70d913e98	2019-10-08 17:09:00	t	2019-10-08 17:09:00	พิชญาภรณ์	กระสินธุ์หอม	หญิง	2019-10-01	\N	\N	\N	\N	\N	\N	\N	$2b$08$6nXrKuan4dnctY3g38Rpduiy1X188hCQBO3CwaSt4acI3gFHRI1KG	q@q.com
459f3630-dd41-4ceb-939c-4860e1994c12	2019-10-10 12:36:27	t	2019-10-10 12:36:27	Palisa	Srilalerng	หญิง	2019-09-04	Suranaree	Mueng	Mueng	Korat	30000	picture-1570780667438.jpg	0880509035	$2b$08$dt4hip9oIysIkHD.ZdBYLebAq1ilUXhsLSfneQRaD8r2289QX3C.G	mind@gmail.com
71133079-afeb-4193-80ec-ec97c61959c7	2019-10-09 14:59:46	t	2019-10-09 14:59:46	fitri2	raso	ชาย	2019-10-08	x	x	x	x	x	\N	x	$2b$08$j4XvKXsPBIVSzC9OIEuQZeBGgpjcuBg.IW4uN63JKzgWxboxcXp6.	u10372
6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	2019-10-08 14:51:08	t	2019-10-08 14:51:08	ณเดช	ราโซ	ชาย	2019-10-02	11	พหลโยธิน 29	จตุจักร	กรุงเทพมหานคร	94000	picture-1570604204412.jpg	0899999999	$2b$08$DpWcBFJTdZbk3BwQluTWAOkkzNn1RW.3gDJWUOhitVV6gJ.3lJoIi	fitto@gmail.com
0114cf7f-2ae4-4c87-802d-905785ee80ea	2019-10-09 11:18:04	t	2019-10-09 11:18:04	พิชญาภรณ์	กระสินธุ์หอม	หญิง	1997-11-18	181 หมู่ที่13	โนนแดง	โนนแดง	นครราชสีมา	30360	picture-1570680414444.jpg	0880509035	$2b$08$w12ufZU237HwUaQLQfbdgODQaJ2OBrc9mExoRWIfG8ugDlT9Sizh6	b5970353@gmail.com
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
94536ab0-df0f-4b47-883f-647e62fea2cc	2019-10-11 11:08:57.265381	t	\N	\N	111 Suranaree Mueng	a7cee017-612b-4c4e-bc0a-5d41ec21f8f6	\N	0880509035	{34f7a8ac-18b4-462f-a275-025eb89698af}	Mueng	Korat	30000	{1}
fb10e93c-4f93-4f6f-8a2f-e84f5ef87061	2019-10-11 11:10:21.12605	t	\N	\N	Suranaree Mueng	cfc72201-2517-4707-820e-c86665ea44d8	\N	0880509035	{855f6a79-d36e-4c4d-9109-de33a3707518}	Mueng	Korat	30000	{1}
ecb9c8a0-654c-4b81-a0e8-2c00110c3a9e	2019-10-11 11:22:01.169858	t	\N	\N	1 2	863cd8ae-ec24-4365-a746-9c8df838e991	\N	4	{cf34840e-14d9-4068-9eb6-6c8fa661c41f}	5	3	6	{1}
0dbfd3dc-9933-4e81-9127-0117700fce73	2019-10-11 11:31:35.063322	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	4234d31a-27a8-42f4-ac5f-bd2d7cb74a0a	\N	0933347977	{34f7a8ac-18b4-462f-a275-025eb89698af}	พนา	bankkok	37180	{12}
708e05f0-7fdb-4584-9d46-ede6bdabd553	2019-10-11 12:22:22.857667	t	\N	\N	Suranaree Mueng	4b0f72ef-b85f-4986-837c-b40bd75edbdb	\N	0880509035	{cf34840e-14d9-4068-9eb6-6c8fa661c41f}	Mueng	Korat	30000	{1}
26ea93e9-e376-4d71-b3dd-0697d00fdb9c	2019-10-11 12:36:26.417491	t	\N	\N	111 Suranaree Mueng	bc42cc24-35cd-4a0e-bfbe-e29a6ccbae2f	\N	0880509035	{855f6a79-d36e-4c4d-9109-de33a3707518,34f7a8ac-18b4-462f-a275-025eb89698af}	Mueng	Korat	30000	{1,1}
a57875e5-6611-436e-acac-9b60e10a761f	2019-10-11 15:06:44.466461	t	\N	\N	Suranaree Mueng	4209c27c-b94c-4cbb-8c37-e8673fba36c0	\N	0880509035	{34f7a8ac-18b4-462f-a275-025eb89698af}	Mueng	Korat	30000	{1}
86d7a3da-73d7-4d4f-9646-7390dec0ab9a	2019-10-11 16:54:12.862794	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	caff9615-cc75-4c80-83d5-c9f4f6bb2ae2	\N	0933347977	{35af0d28-57f5-4eae-8075-513921404b00}	พนา	bankkok	37180	{500}
c9ccb2b0-af2c-441c-b234-f5bf6fcfe940	2019-10-11 16:55:28.144183	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	500f27fc-bf61-46a1-b813-76ea2af864ac	\N	0933347977	{35af0d28-57f5-4eae-8075-513921404b00}	พนา	bankkok	37180	{500}
f66600e1-06fd-46ce-af72-8bdfa2d8b728	2019-10-11 16:55:32.97731	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	7d32e150-179d-459c-8328-7d5d9f3b4f8d	\N	0933347977	{35af0d28-57f5-4eae-8075-513921404b00}	พนา	bankkok	37180	{500}
bcc13964-2715-4b20-818c-0d8c90f6390c	2019-10-11 16:55:42.047166	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	c25d9229-42b6-4e01-b980-12491ed4b8ec	\N	0933347977	{35af0d28-57f5-4eae-8075-513921404b00}	พนา	bankkok	37180	{500}
29af6971-6501-4f3c-9a6e-9fa4f0732531	2019-10-11 16:57:20.044495	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	b7e13fdf-51b4-435d-86a5-a0713d77c66f	\N	0933347977	{35af0d28-57f5-4eae-8075-513921404b00}	พนา	bankkok	37180	{500}
659eecf7-4deb-45a5-a730-8edc0f7f1786	2019-10-11 16:59:05.486097	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	a85cc49f-08db-4dc0-9059-d0be3c93312b	\N	0933347977	{34f7a8ac-18b4-462f-a275-025eb89698af}	พนา	bankkok	37180	{500}
bac1aa46-638d-4b21-86cd-8b292be65dfa	2019-10-11 17:00:03.607495	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	f69bde1e-594b-489a-88e5-d40f5427cf3b	\N	0933347977	{34f7a8ac-18b4-462f-a275-025eb89698af}	พนา	bankkok	37180	{500}
9da89098-f1d0-4501-9e6c-9f876c999434	2019-10-11 17:01:25.262815	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	23721955-7225-4a4a-8d3e-c432dfa8825b	\N	0933347977	{34f7a8ac-18b4-462f-a275-025eb89698af}	พนา	bankkok	37180	{500}
f8c82fdf-d3a6-4863-b85f-8232fd75069d	2019-10-11 17:01:52.709689	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	a0116f46-be7d-46ac-9262-0d1550cd8a67	\N	0933347977	{34f7a8ac-18b4-462f-a275-025eb89698af}	พนา	bankkok	37180	{500}
0cfef297-b34a-4cb2-9ca9-b7c3f62c8ad9	2019-10-11 17:02:41.516014	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	f4b3a8db-ee01-49a6-8b4d-7fda9e9f1374	\N	0933347977	{56605fdc-af11-4f06-8791-f729c0e2b85a}	พนา	bankkok	37180	{500}
acc5d7de-0c07-452f-b445-a45e5c3b815a	2019-10-11 17:03:37.224491	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	37e4c249-5f96-4e6d-94e7-7bce559c6058	\N	0933347977	{56605fdc-af11-4f06-8791-f729c0e2b85a}	พนา	bankkok	37180	{500}
75bae6cf-17b6-4e90-ad4f-b356ad2197e7	2019-10-11 17:03:52.074746	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	349d5e61-3a51-424d-86e7-64776f8b99e1	\N	0933347977	{56605fdc-af11-4f06-8791-f729c0e2b85a}	พนา	bankkok	37180	{500}
d768f99d-0f71-4646-868e-f277ed0c091d	2019-10-11 17:05:09.926844	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	83745d0a-4024-4178-a0f6-ef01f9598149	\N	0933347977	{56605fdc-af11-4f06-8791-f729c0e2b85a}	พนา	bankkok	37180	{500}
a9101f9f-04fe-4fce-aeed-7fbe341f0a17	2019-10-11 17:05:53.777571	t	\N	\N	กรุงเทพมหานคร ถ.ม่วง ต.จังไร 	af5c4aca-a77b-42c8-9e86-b0f6dffa2d9f	\N	0933347977	{56605fdc-af11-4f06-8791-f729c0e2b85a}	พนา	bankkok	37180	{500}
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
dd9c3852-ee45-4512-b036-380e960bc5b8	2019-10-10 16:19:36.196759	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	758d9371-16f3-4d69-bc65-b222dbe6661e	a868b97f-c34f-4a1e-bdee-06dd57d49edb	\N	{4cbd562f-8191-49e7-81ae-e7c85447ac2c}
1272907b-182b-469d-998a-54dfeae42a52	2019-10-10 12:37:44.019681	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	deda128e-fece-497b-9a99-f882a6a6cb87	733aa274-1129-4e75-a5be-cf3f28b1cd5c	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673}
1bee3552-ec5e-4414-8940-b3991f50104c	2019-10-09 16:16:39.41517	t	\N	6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	7e89282d-012a-4722-b68d-92a0b3269157	a64bfef1-819d-4069-b380-9d2c0cf20e9c	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673}
125d5548-1a8c-4dd3-9a5b-e0969811857a	2019-10-09 13:52:42.564963	t	\N	6bb42d75-fe8d-4ce6-89a8-e68dc9c206f5	9d758b34-c78f-4b09-bb5a-6dfd2c53c320	4819a812-1e82-4038-b400-0d9d59459e38	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3}
f1976b93-e83e-41f9-81fa-6bb927d661eb	2019-10-10 16:19:24.352146	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	af409fd3-d502-4b86-83d3-0fb54af25834	0be66b3a-278b-4b8a-b828-1d290eef4cdf	\N	{4cbd562f-8191-49e7-81ae-e7c85447ac2c}
863cd8ae-ec24-4365-a746-9c8df838e991	2019-10-11 11:22:01.145741	t	\N	e8ef5c77-434d-467e-9146-06f3f8fb80ae	9e99b791-80b4-4285-b132-df0eae7936e5	\N	\N	{4cbd562f-8191-49e7-81ae-e7c85447ac2c}
4234d31a-27a8-42f4-ac5f-bd2d7cb74a0a	2019-10-11 11:31:35.014816	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	4fa5c6e5-42f0-4934-b795-115a0744a65e	\N	\N	{35af0d28-57f5-4eae-8075-513921404b00}
c970229d-1a23-4008-a450-9793fc46f4cb	2019-10-10 12:45:10.567118	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	182f6aee-e78f-4746-b51c-48ce77f7a24f	3a3e1b86-8214-4e3c-bc51-8006fb3916cf	\N	{705f4aa2-d1d0-4550-ba18-3ae328f57673}
a7cee017-612b-4c4e-bc0a-5d41ec21f8f6	2019-10-11 11:08:57.229253	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	11ae2069-a31d-4cca-8d4b-114a2add931a	eae497d0-794c-47a8-9d4e-47f986aa030b	\N	{35af0d28-57f5-4eae-8075-513921404b00}
cfc72201-2517-4707-820e-c86665ea44d8	2019-10-11 11:10:21.079241	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	bc8ff817-134a-488f-af73-36744cd50845	8e3f6796-cb9e-4e86-ad0d-b0f6356d8a75	\N	{4cbd562f-8191-49e7-81ae-e7c85447ac2c}
0a36579a-d68f-4676-8698-48e07716af6d	2019-10-10 15:10:37.727834	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	e119a0aa-72a5-46ea-92cd-e9f954ef6cf1	cdd27490-a8b1-4e04-a48d-5af201b400b9	\N	{eb27cc47-fd1b-455f-aae0-bb15db16fff3}
4b0f72ef-b85f-4986-837c-b40bd75edbdb	2019-10-11 12:22:22.822771	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	f37bcc98-09a8-41ba-a993-222fe8998fd0	0512cf30-2394-481b-8c0e-64310fe5ab2b	\N	{4cbd562f-8191-49e7-81ae-e7c85447ac2c}
bc42cc24-35cd-4a0e-bfbe-e29a6ccbae2f	2019-10-11 12:36:26.368772	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	96e677da-3a24-466c-8666-da857b1222ec	\N	\N	{4cbd562f-8191-49e7-81ae-e7c85447ac2c,35af0d28-57f5-4eae-8075-513921404b00}
4209c27c-b94c-4cbb-8c37-e8673fba36c0	2019-10-11 15:06:44.44261	t	\N	459f3630-dd41-4ceb-939c-4860e1994c12	f646ebc9-806d-4903-9972-eac85eecf491	\N	\N	{35af0d28-57f5-4eae-8075-513921404b00}
caff9615-cc75-4c80-83d5-c9f4f6bb2ae2	2019-10-11 16:54:12.942708	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	fe0753ae-4968-4f2d-80ea-18330a0a8a07	\N	\N	{34f7a8ac-18b4-462f-a275-025eb89698af}
500f27fc-bf61-46a1-b813-76ea2af864ac	2019-10-11 16:55:28.18451	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	617fe057-8fd8-4307-bee4-05d5bd2eccaa	\N	\N	{34f7a8ac-18b4-462f-a275-025eb89698af}
7d32e150-179d-459c-8328-7d5d9f3b4f8d	2019-10-11 16:55:33.025993	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	5b75efcc-3939-401a-84a2-10b9214c1db6	\N	\N	{34f7a8ac-18b4-462f-a275-025eb89698af}
c25d9229-42b6-4e01-b980-12491ed4b8ec	2019-10-11 16:55:42.082166	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	9fa53839-3ac3-4d87-a7fa-0d7c78b64af7	\N	\N	{34f7a8ac-18b4-462f-a275-025eb89698af}
b7e13fdf-51b4-435d-86a5-a0713d77c66f	2019-10-11 16:57:20.078806	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	3b8e550d-cabd-4fad-817e-458b58385cae	\N	\N	{34f7a8ac-18b4-462f-a275-025eb89698af}
a85cc49f-08db-4dc0-9059-d0be3c93312b	2019-10-11 16:59:05.530039	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	8d2b79b2-4fd2-44d0-9921-c16dba1605b4	\N	\N	{35af0d28-57f5-4eae-8075-513921404b00}
f69bde1e-594b-489a-88e5-d40f5427cf3b	2019-10-11 17:00:03.638919	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	8e198c85-a689-43b5-9016-b1d3b29694fe	\N	\N	{35af0d28-57f5-4eae-8075-513921404b00}
23721955-7225-4a4a-8d3e-c432dfa8825b	2019-10-11 17:01:25.306551	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	d6a1d798-4d8a-430a-b0b8-105fc6c72192	\N	\N	{35af0d28-57f5-4eae-8075-513921404b00}
a0116f46-be7d-46ac-9262-0d1550cd8a67	2019-10-11 17:01:52.742401	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	e738680f-0b3f-4605-8abe-65b47f38a950	\N	\N	{35af0d28-57f5-4eae-8075-513921404b00}
f4b3a8db-ee01-49a6-8b4d-7fda9e9f1374	2019-10-11 17:02:41.552454	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	9661b234-794f-4500-a643-82ea20094b34	\N	\N	{35af0d28-57f5-4eae-8075-513921404b00}
37e4c249-5f96-4e6d-94e7-7bce559c6058	2019-10-11 17:03:37.279621	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	b0f0e8b0-eadd-4f38-a532-6a6db4500e18	\N	\N	{35af0d28-57f5-4eae-8075-513921404b00}
349d5e61-3a51-424d-86e7-64776f8b99e1	2019-10-11 17:03:52.113889	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	cf0399b9-48f9-4252-a92b-683212806dc5	\N	\N	{35af0d28-57f5-4eae-8075-513921404b00}
83745d0a-4024-4178-a0f6-ef01f9598149	2019-10-11 17:05:09.97477	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	2e551e27-0bd7-4d6f-8550-e207f43b4683	\N	\N	{35af0d28-57f5-4eae-8075-513921404b00}
af5c4aca-a77b-42c8-9e86-b0f6dffa2d9f	2019-10-11 17:05:53.810512	t	\N	1f5b966d-b36f-480f-b494-21c784e6f2eb	78a6c297-2358-4e40-a047-e9031cbf9ba8	\N	\N	{35af0d28-57f5-4eae-8075-513921404b00}
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.payment (payid, createdate, active, datemodify, slip, summary, datepayment, paystatusid, summarycheck) FROM stdin;
bc8ff817-134a-488f-af73-36744cd50845	2019-10-11 11:10:20.872145	t	\N	picture	270	2019-10-11 11:40:35	3	\N
e119a0aa-72a5-46ea-92cd-e9f954ef6cf1	2019-10-10 15:10:37.698106	t	\N	picture	500	2019-10-02 13:17:40	3	\N
f37bcc98-09a8-41ba-a993-222fe8998fd0	2019-10-11 12:22:22.771483	t	\N	picture	600	2019-10-11 13:22:56	3	\N
96e677da-3a24-466c-8666-da857b1222ec	2019-10-11 12:36:26.248905	t	\N	picture	5770	2019-10-01 13:36:51	2	\N
f646ebc9-806d-4903-9972-eac85eecf491	2019-10-11 15:06:44.065177	t	\N	\N	\N	\N	1	\N
fe0753ae-4968-4f2d-80ea-18330a0a8a07	2019-10-11 16:54:12.863126	t	\N	\N	\N	\N	1	\N
617fe057-8fd8-4307-bee4-05d5bd2eccaa	2019-10-11 16:55:28.145223	t	\N	\N	\N	\N	1	\N
5b75efcc-3939-401a-84a2-10b9214c1db6	2019-10-11 16:55:32.978423	t	\N	\N	\N	\N	1	\N
9fa53839-3ac3-4d87-a7fa-0d7c78b64af7	2019-10-11 16:55:42.047981	t	\N	\N	\N	\N	1	\N
3b8e550d-cabd-4fad-817e-458b58385cae	2019-10-11 16:57:20.044602	t	\N	\N	\N	\N	1	\N
222b00ab-a3dd-4002-a842-e32583ff1434	2019-10-08 14:24:53.694214	t	\N	\N	\N	\N	1	\N
d8b7619f-1581-4590-b0c9-411ca1323692	2019-10-08 14:25:20.847625	t	\N	\N	\N	\N	1	\N
8d2b79b2-4fd2-44d0-9921-c16dba1605b4	2019-10-11 16:59:05.486426	t	\N	\N	\N	\N	1	\N
8e198c85-a689-43b5-9016-b1d3b29694fe	2019-10-11 17:00:03.608244	t	\N	\N	\N	\N	1	\N
d6a1d798-4d8a-430a-b0b8-105fc6c72192	2019-10-11 17:01:25.262878	t	\N	\N	\N	\N	1	\N
e738680f-0b3f-4605-8abe-65b47f38a950	2019-10-11 17:01:52.710357	t	\N	\N	\N	\N	1	\N
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
9661b234-794f-4500-a643-82ea20094b34	2019-10-11 17:02:41.516211	t	\N	\N	\N	\N	1	\N
b0f0e8b0-eadd-4f38-a532-6a6db4500e18	2019-10-11 17:03:37.224761	t	\N	\N	\N	\N	1	\N
78cc9c64-2bb8-4f53-9582-3d868d4a2845	2019-10-09 15:00:34.225941	t	\N	\N	\N	\N	1	\N
a17341de-e6a8-4634-9e76-f3fcb4913f8e	2019-10-09 16:16:58.987313	t	\N	\N	\N	\N	1	\N
cf0399b9-48f9-4252-a92b-683212806dc5	2019-10-11 17:03:52.077148	t	\N	\N	\N	\N	1	\N
8599b737-788f-42af-b502-f5ca3a4c9140	2019-10-10 12:09:22.442769	t	\N	\N	\N	\N	1	\N
65944273-675d-42cb-bd53-abd5493a6692	2019-10-10 12:11:03.529348	t	\N	\N	\N	\N	1	\N
bdbfab53-0647-46aa-89a6-08790fea00b7	2019-10-10 12:12:46.853612	t	\N	\N	\N	\N	1	\N
b7a2608c-a625-47e5-8d08-df4dfb7d017d	2019-10-10 12:32:44.632713	t	\N	\N	\N	\N	1	\N
2e551e27-0bd7-4d6f-8550-e207f43b4683	2019-10-11 17:05:09.928541	t	\N	\N	\N	\N	1	\N
78a6c297-2358-4e40-a047-e9031cbf9ba8	2019-10-11 17:05:53.778874	t	\N	\N	\N	\N	1	\N
deda128e-fece-497b-9a99-f882a6a6cb87	2019-10-10 12:37:43.961331	t	\N	picture	830	2019-10-10 12:39:58	3	\N
7e89282d-012a-4722-b68d-92a0b3269157	2019-10-09 16:16:39.371549	t	\N	picture	500	2019-09-30 12:16:33	3	\N
07148724-b5d1-44c7-a904-450f651745f7	2019-10-09 13:40:54.878674	t	\N	picture	888	2019-10-09 13:51:10	3	\N
758d9371-16f3-4d69-bc65-b222dbe6661e	2019-10-10 16:19:36.16541	t	\N	picture	600	2019-10-10 17:25:17	3	\N
9d758b34-c78f-4b09-bb5a-6dfd2c53c320	2019-10-09 13:52:42.536167	t	\N	picture	89888	2019-10-09 13:51:10	3	\N
af409fd3-d502-4b86-83d3-0fb54af25834	2019-10-10 16:19:24.2868	t	\N	picture	1000	2019-10-11 10:54:40	3	\N
9e99b791-80b4-4285-b132-df0eae7936e5	2019-10-11 11:22:01.117859	t	\N	\N	\N	\N	1	\N
4fa5c6e5-42f0-4934-b795-115a0744a65e	2019-10-11 11:31:34.888029	t	\N	\N	\N	\N	1	\N
182f6aee-e78f-4746-b51c-48ce77f7a24f	2019-10-10 12:45:10.538149	t	\N	picture	1000	2019-10-11 10:29:13	3	\N
11ae2069-a31d-4cca-8d4b-114a2add931a	2019-10-11 11:08:57.054539	t	\N	picture	5550	2019-10-01 12:35:38	3	\N
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
e2078ad4-40a0-452c-afdd-36fd6227a6ff	2019-10-10 15:41:23.728537	t	\N	ส้ม	ส้มคัดคุณภาพ	{picture-1570696656146.jpg}	4cbd562f-8191-49e7-81ae-e7c85447ac2c	\N	2019-10-10 15:41:23	2019-10-10 22:00:00	fruit
d92ed07c-a262-4294-a472-74f58c3456ce	2019-10-10 16:18:39.361533	t	\N	กระเป๋าสะพายข้าง	พกพาสะดวก 	{picture-1570696834539.jpg}	4cbd562f-8191-49e7-81ae-e7c85447ac2c	\N	2019-10-10 16:18:39	2019-10-11 01:20:00	bag
98823545-b460-4039-ad85-e3e56236f9a8	2019-10-11 10:25:32.766476	t	\N	ชุดสูท	ดูดี มีระดับ	{picture-1570695926234.jpg}	35af0d28-57f5-4eae-8075-513921404b00	\N	2019-10-11 10:25:32	2019-10-11 17:30:00	clothes
68a40482-fe8c-489a-814b-1b10e3fdc804	2019-10-11 10:27:32.739386	t	\N	ส้ม	ส้มคัดคุณภาพ	{picture-1570696656146.jpg}	4cbd562f-8191-49e7-81ae-e7c85447ac2c	\N	2019-10-11 10:27:32	2019-10-11 19:40:00	fruit
36e4f41e-86fa-4e66-9816-7b232819b9e8	2019-10-11 10:44:48.63212	t	\N	กระเป๋าสะพายข้าง	พกพาสะดวก 	{picture-1570696834539.jpg}	4cbd562f-8191-49e7-81ae-e7c85447ac2c	\N	2019-10-11 10:44:48	2019-10-11 19:00:00	bag
e8c3e5f5-81f2-45e5-b6ca-11eaf254500b	2019-10-10 15:40:34.573321	t	2019-10-10 15:40:34	กระเป๋าสะพายข้าง	พกพาสะดวก 	{picture-1570696834539.jpg}	4cbd562f-8191-49e7-81ae-e7c85447ac2c	\N	\N	\N	bag
\.


--
-- Data for Name: productoption; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.productoption (proopid, createdate, active, datemodify, price, includingvat, optionvalue, proid, types, sku, totalproduct) FROM stdin;
4b391e19-3c74-4209-9e44-c8e971b23634	2019-10-08 14:19:13.881583	t	2019-10-08 14:19:13	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"A\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"15 kg\\"}"}	ae8933b3-aff9-4a3e-bf13-01d2ba21e013	order	F001	990
79f3ca87-f056-44fc-9335-45db277f98de	2019-10-08 16:22:51.592815	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"M\\"}"}	39d714f4-a2c5-41bc-bd9c-f1678872c1b8	preorder	S002	990
92cab296-1a41-4e94-b500-7145e91c5b73	2019-10-08 16:22:51.593246	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}"}	39d714f4-a2c5-41bc-bd9c-f1678872c1b8	preorder	S003	990
df8bb2f9-98ec-41ce-ba38-3106fc3c291d	2019-10-08 16:42:35.351622	t	\N	2300	150.469999999999999	{"{\\"name\\":\\"ประเภท\\",\\"value\\":\\"ชุดนักเรียน\\"}","{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}"}	f44d99fe-db38-4f7e-988e-176e443e7ee2	preorder	STD001	990
245b59b9-09b8-40d2-a885-3ce640eaf162	2019-10-08 16:42:35.356847	t	\N	2300	150.469999999999999	{"{\\"name\\":\\"ประเภท\\",\\"value\\":\\"ชุด รด\\"}","{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}"}	f44d99fe-db38-4f7e-988e-176e443e7ee2	preorder	STD002	990
cc86a609-336a-4e10-8d69-c469cbb8aa89	2019-10-08 17:01:23.310944	t	2019-10-08 17:01:23	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"1.5 kg\\"}"}	6dbefa8c-3b13-4892-abc6-ff553a56e26b	order	WM001	990
45b2fda9-ce8a-4570-8b14-dc316f5592a8	2019-10-08 17:01:23.278253	t	2019-10-08 17:01:23	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"5 kg\\"}"}	6dbefa8c-3b13-4892-abc6-ff553a56e26b	order	WM002	990
797d003c-5bc1-4ce2-82e2-55320a634f2a	2019-10-08 17:02:32.036904	t	2019-10-08 17:02:32	890	58.2199999999999989	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"เล็ก\\"}"}	d15bd560-6c01-46e5-9986-50a961c21285	order	H001	990
9cffea1b-3292-4007-bf3d-225333ace1c9	2019-10-10 15:41:23.764949	t	\N	220	14.3900000000000006	{"{\\"name\\":\\"สายพันธุ์\\",\\"value\\":\\"สายน้ำผึ้ง\\"}"}	e2078ad4-40a0-452c-afdd-36fd6227a6ff	preorder	FR-ORG-001	990
9cc89cea-20eb-4d3e-be4f-3922ad550e84	2019-10-08 17:02:32.007845	t	2019-10-08 17:02:32	1500	98.1299999999999955	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"ใหญ่\\"}"}	d15bd560-6c01-46e5-9986-50a961c21285	order	H002	990
22ad1d90-4a78-466c-b2ec-16616e8f8a50	2019-10-08 17:04:17.812305	t	2019-10-08 17:04:17	780	51.0300000000000011	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ขาว-เทา\\"}"}	f8d21608-3e78-4c1b-aed6-bf0d6817b502	order	HB001	990
43835e93-fd8c-49dd-876c-cd0de13eef26	2019-10-08 17:04:17.735237	t	2019-10-08 17:04:17	890	58.2199999999999989	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ-แดง\\"}"}	f8d21608-3e78-4c1b-aed6-bf0d6817b502	order	HB002	990
80c3cf78-529e-49a5-9ca4-cbcd892e9f69	2019-10-08 17:06:34.766394	t	2019-10-08 17:06:34	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"5 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	14c3ac7b-edef-4497-be38-fff7de129bed	order	CE001	990
be308ac7-4ad7-4e73-9b77-26d1577eb81f	2019-10-08 17:06:34.721861	t	2019-10-08 17:06:34	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"แดง\\"}"}	14c3ac7b-edef-4497-be38-fff7de129bed	order	CE002	990
b9f099f1-1764-4762-ada4-280fb58045ee	2019-10-08 17:06:34.766649	t	2019-10-08 17:06:34	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	14c3ac7b-edef-4497-be38-fff7de129bed	order	CE003	990
ff7d76eb-82ec-4823-88c6-11e106566aff	2019-10-08 17:07:27.290894	t	\N	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"แดง\\"}"}	6a083bf1-54a5-4275-96d6-4d7cd7eb27a3	preorder	CE002	990
938ec6e1-7bee-4a65-815c-949c1758a7b6	2019-10-08 17:07:50.113194	t	\N	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"1.5 kg\\"}"}	9c7131df-09eb-4485-840a-31537077d3b2	preorder	WM001	990
64d39e3b-ccc7-4dce-b1b6-bd68dfa39b6e	2019-10-08 17:07:50.118014	t	\N	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"5 kg\\"}"}	9c7131df-09eb-4485-840a-31537077d3b2	preorder	WM002	990
2f39ecf7-dcec-4b7b-9519-e143219d5c79	2019-10-08 17:08:22.382028	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"เล็ก\\"}"}	25fe2fd2-d6ba-4567-8943-c04cfaede4ef	preorder	H001	990
66c43745-7e22-4d51-8b73-f05bc6184ea3	2019-10-08 17:08:22.382761	t	\N	1500	98.1299999999999955	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"ใหญ่\\"}"}	25fe2fd2-d6ba-4567-8943-c04cfaede4ef	preorder	H002	990
7fe46d0c-e842-404f-8fe6-1d91e4d57eff	2019-10-08 17:08:48.56083	t	\N	780	51.0300000000000011	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ขาว-เทา\\"}"}	d9bb5df7-969f-454e-b1f3-7857df53cc64	preorder	HB001	990
95a606a7-4e4b-4032-aab2-508426449e48	2019-10-08 17:07:27.291091	t	\N	9999999999999	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	6a083bf1-54a5-4275-96d6-4d7cd7eb27a3	preorder	CE003	990
7b966601-afa0-4723-906f-cd0c7b11e31f	2019-10-08 14:21:21.168195	t	2019-10-08 14:21:21	500	32.7100000000000009	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"1 ตัว\\"}"}	71439d4f-35be-47aa-9eb1-7f846fab4ed2	order	E001	990
1e456eed-7a13-49cd-bd18-d8326e0ecfae	2019-10-09 10:47:14.37648	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"A\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"15 kg\\"}"}	3870800e-0747-4226-9a76-3102de9f9911	preorder	F001	990
7c91f21b-326b-4a7b-a0bb-492586eca7b9	2019-10-09 10:47:14.382517	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}"}	3870800e-0747-4226-9a76-3102de9f9911	preorder	F002	990
510619d6-fb59-43aa-bf61-e0e5a3732f83	2019-10-09 10:47:14.38303	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"10 kg\\"}"}	3870800e-0747-4226-9a76-3102de9f9911	preorder	F003	990
aa814f5f-8af5-4c53-943d-a0ab54e018c6	2019-10-09 11:15:16.821711	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"เล็ก\\"}"}	5d22486e-db77-45f3-a4e1-e5b66c670a4a	preorder	H001	990
bb5bb540-9db1-4ed1-a01e-c7365ddb7303	2019-10-09 11:15:16.826902	t	\N	1500	98.1299999999999955	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"ใหญ่\\"}"}	5d22486e-db77-45f3-a4e1-e5b66c670a4a	preorder	H002	990
3eba6edb-ec04-480b-8dea-dcc5453fe0f4	2019-10-09 11:19:48.356922	t	\N	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"1.5 kg\\"}"}	194bcc26-234a-490d-97d8-87bc711cdc88	preorder	WM001	990
53d1d3bc-a257-4624-a9a7-b479b9553b1f	2019-10-09 11:19:48.357165	t	\N	260	17.0100000000000016	{"{\\"name\\":\\"น้ำหนัก\\",\\"value\\":\\"5 kg\\"}"}	194bcc26-234a-490d-97d8-87bc711cdc88	preorder	WM002	990
4f4c0b31-15f9-48dd-941f-694bcdeaac1d	2019-10-10 10:40:07.317543	t	\N	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"1 ตัว\\"}"}	ffb5565a-dc48-4fd3-b1a5-8c197fb10853	preorder	EE001	990
c75eccb3-5230-4278-accf-6e4cef60a27d	2019-10-10 10:40:07.325606	t	\N	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"5 ตัว\\"}"}	ffb5565a-dc48-4fd3-b1a5-8c197fb10853	preorder	EE002	990
1152c7cd-4d9b-4d7a-80e1-5ab14da8d4e0	2019-10-10 10:40:55.949534	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"A\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"15 kg\\"}"}	33f379b7-7c00-48d9-b0c0-8bff2e005f80	preorder	F001	990
71f64bfc-40af-4d81-bb61-42f3675d9284	2019-10-10 10:40:55.961305	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}"}	33f379b7-7c00-48d9-b0c0-8bff2e005f80	preorder	F002	990
4596ab0d-1e8b-47ec-a88e-32977cb1fc44	2019-10-10 10:40:55.962107	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"10 kg\\"}"}	33f379b7-7c00-48d9-b0c0-8bff2e005f80	preorder	F003	990
b6b7dadb-d667-4a2f-9f4a-12b5f1dfc5fe	2019-10-10 10:45:55.553702	t	\N	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"5 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	99005d89-759d-4ab8-a11e-0ccd386c5caa	preorder	CE001	990
beb76969-5dde-45b7-893f-c9d69d545a56	2019-10-10 10:45:55.55708	t	\N	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"แดง\\"}"}	99005d89-759d-4ab8-a11e-0ccd386c5caa	preorder	CE002	990
56605fdc-af11-4f06-8791-f729c0e2b85a	2019-10-11 10:25:32.986487	t	\N	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"white\\"}"}	98823545-b460-4039-ad85-e3e56236f9a8	preorder	SUIT002	490
d6488c3e-7e19-4019-81be-7f71dffa4d25	2019-10-08 17:08:48.566561	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ-แดง\\"}"}	d9bb5df7-969f-454e-b1f3-7857df53cc64	preorder	HB002	990
f7a051f0-40e3-4e06-b690-7d950a6f6ae9	2019-10-10 10:45:55.557767	t	\N	3500	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"4 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	99005d89-759d-4ab8-a11e-0ccd386c5caa	preorder	CE003	990
01065ea7-8823-4048-85cf-aa30fe119538	2019-10-10 10:46:47.979411	t	\N	780	51.0300000000000011	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ขาว-เทา\\"}"}	2100df1e-2c56-4627-9351-4dd1d552d693	preorder	HB001	990
2ab9b897-ef4f-4676-a2d1-4bba7b560c7e	2019-10-10 10:46:47.983063	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ-แดง\\"}"}	2100df1e-2c56-4627-9351-4dd1d552d693	preorder	HB002	990
d46dfdb2-9e5a-44e4-9f7f-12ceb69fea57	2019-10-10 10:47:55.997396	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"S\\"}"}	fa0ad9af-ebbd-41d9-ab15-1088bceb5291	preorder	S001	990
b4ebcc48-11de-4473-a030-8e0b36ea99bb	2019-10-10 10:47:56.000608	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"M\\"}"}	fa0ad9af-ebbd-41d9-ab15-1088bceb5291	preorder	S002	990
b413f0fc-0eb6-4b7b-8289-1d8ca29bc05c	2019-10-10 10:47:56.000953	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}"}	fa0ad9af-ebbd-41d9-ab15-1088bceb5291	preorder	S003	990
764638f1-280a-4ce5-b908-cc92f0169560	2019-10-10 10:49:21.111392	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"เล็ก\\"}"}	9f52df71-701e-4ac5-9a81-884ce5f2d21f	preorder	H001	990
e2449b65-152d-4b3b-a626-f2afdb54f848	2019-10-10 10:49:21.114874	t	\N	1500	98.1299999999999955	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"ใหญ่\\"}"}	9f52df71-701e-4ac5-9a81-884ce5f2d21f	preorder	H002	990
c05c0b24-827d-424e-8e2d-7981dfda8632	2019-10-10 15:28:08.795901	t	\N	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"black\\"}"}	4f1c32ae-fea6-40e8-b174-0bb9cc2c72b1	preorder	SUIT001	990
74e552b6-c654-4722-9a43-7b582f3befa0	2019-10-08 17:07:27.284862	t	\N	9999999999999	228.969999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"5 คิว\\"}","{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	6a083bf1-54a5-4275-96d6-4d7cd7eb27a3	preorder	CE001	990
8cc5e66a-912f-410e-9e87-63bfcd4307e5	2019-10-10 11:25:02.800041	t	2019-10-10 11:25:02	2505	163.550000000000011	{"{\\"name\\":\\"ัสี\\",\\"value\\":\\"ขาว\\"}","{\\"name\\":\\"ไซต์\\",\\"value\\":\\"L\\"}"}	e29c982a-bade-4a88-95d9-15f9637f19ca	order	C002	990
8d13b852-5f9c-4dde-b48c-94919e8d4581	2019-10-10 16:18:39.397176	t	\N	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"แดง\\"}"}	d92ed07c-a262-4294-a472-74f58c3456ce	preorder	BAG-SIDE-003	990
d8526baa-38b7-4138-96c4-f498759a4e67	2019-10-10 16:18:39.397412	t	\N	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	d92ed07c-a262-4294-a472-74f58c3456ce	preorder	BAG-SIDE-002	990
34f7a8ac-18b4-462f-a275-025eb89698af	2019-10-11 10:25:32.978647	t	\N	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"black\\"}"}	98823545-b460-4039-ad85-e3e56236f9a8	preorder	SUIT001	990
e3d80bdb-a7d5-4b68-a843-b1fc01f5ee36	2019-10-08 14:23:32.569148	t	\N	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"1 ตัว\\"}"}	3450b950-3803-4881-a146-cf27dd81ccc6	preorder	EE001	990
efc0047a-8ba3-4c53-9b14-47abe1e0488d	2019-10-08 14:23:32.574301	t	\N	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"5 ตัว\\"}"}	3450b950-3803-4881-a146-cf27dd81ccc6	preorder	EE002	990
08b9120a-4a04-48c7-89bb-1a48e1fcf6a6	2019-10-08 16:18:47.546093	t	2019-10-08 16:18:47	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"S\\"}"}	43426d51-2bf8-4928-92ba-6ae3aed58233	order	S001	990
28fe4afc-d7ba-40db-923e-4946f202c3e4	2019-10-08 16:18:47.425536	t	2019-10-08 16:18:47	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"M\\"}"}	43426d51-2bf8-4928-92ba-6ae3aed58233	order	S002	990
9f00df72-05d0-44da-bc1e-8c50c7c52238	2019-10-08 16:18:47.546762	t	2019-10-08 16:18:47	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}"}	43426d51-2bf8-4928-92ba-6ae3aed58233	order	S003	990
e7cb80d5-99ac-4631-8e38-6a676bfcef7a	2019-10-08 16:22:13.72287	t	2019-10-08 16:22:13	2300	150.469999999999999	{"{\\"name\\":\\"ประเภท\\",\\"value\\":\\"ชุดนักเรียน\\"}","{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}"}	b72c5c71-f7e1-44e8-aa40-5681b01f5a80	order	STD001	990
76757920-6c46-4dad-a51b-0c1b4424f0a7	2019-10-08 16:22:13.687162	t	2019-10-08 16:22:13	2300	150.469999999999999	{"{\\"name\\":\\"ประเภท\\",\\"value\\":\\"ชุด รด\\"}","{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}"}	b72c5c71-f7e1-44e8-aa40-5681b01f5a80	order	STD002	990
08a925fa-62a3-4090-b406-64166305c051	2019-10-10 15:40:34.573009	t	2019-10-10 15:40:34	600	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	e8c3e5f5-81f2-45e5-b6ca-11eaf254500b	order	BAG-SIDE-002	990
3f6dba7b-f2cf-46bf-be09-6704cbcd506a	2019-10-11 10:25:32.986819	t	\N	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"black\\"}"}	98823545-b460-4039-ad85-e3e56236f9a8	preorder	SUIT003	990
855f6a79-d36e-4c4d-9109-de33a3707518	2019-10-11 10:27:32.789216	t	\N	220	14.3900000000000006	{"{\\"name\\":\\"สายพันธุ์\\",\\"value\\":\\"สายน้ำผึ้ง\\"}"}	68a40482-fe8c-489a-814b-1b10e3fdc804	preorder	FR-ORG-001	990
c806b666-7cf6-4a18-a4a0-c5f3f63e04e3	2019-10-11 10:27:32.794433	t	\N	220	14.3900000000000006	{"{\\"name\\":\\"สายพันธุ์\\",\\"value\\":\\"เขียวหวาน\\"}"}	68a40482-fe8c-489a-814b-1b10e3fdc804	preorder	FR-ORG-002	990
cf34840e-14d9-4068-9eb6-6c8fa661c41f	2019-10-11 10:44:48.665865	t	\N	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"เทา\\"}"}	36e4f41e-86fa-4e66-9816-7b232819b9e8	preorder	BAG-SIDE-001	990
a8b70fa1-1924-4d9b-b784-d488435c444b	2019-10-11 10:44:48.671187	t	\N	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"ดำ\\"}"}	36e4f41e-86fa-4e66-9816-7b232819b9e8	preorder	BAG-SIDE-002	990
6c3d269b-fb26-452d-95bc-92d2eb71806c	2019-10-11 10:44:48.671741	t	\N	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"แดง\\"}"}	36e4f41e-86fa-4e66-9816-7b232819b9e8	preorder	BAG-SIDE-003	990
faf0cb5a-92ec-4189-a749-b1daf24cd4cc	2019-10-10 15:40:34.603605	t	2019-10-10 15:40:34	720	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"แดง\\"}"}	e8c3e5f5-81f2-45e5-b6ca-11eaf254500b	order	BAG-SIDE-003	990
eac65010-c64d-4fb9-a0a5-c60d70288400	2019-10-10 15:40:34.601105	t	2019-10-10 15:40:34	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"เทา\\"}"}	e8c3e5f5-81f2-45e5-b6ca-11eaf254500b	order	BAG-SIDE-001	990
25b5e885-5a61-49d7-93cd-1dd069406ff1	2019-10-08 14:19:13.804802	t	2019-10-08 14:19:13	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}"}	ae8933b3-aff9-4a3e-bf13-01d2ba21e013	order	F002	990
3a94d462-a31b-43cf-9e2e-caff60887e3e	2019-10-08 14:19:13.885466	t	2019-10-08 14:19:13	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"10 kg\\"}"}	ae8933b3-aff9-4a3e-bf13-01d2ba21e013	order	F003	990
60595e64-28e7-440a-b442-7369bbf84b5a	2019-10-08 14:19:44.656491	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"A\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"15 kg\\"}"}	303729f1-67ea-4baf-94d8-b8081e8a9b4f	preorder	F001	990
6ef43b86-7862-4a62-99f3-d5eb49a170f4	2019-10-08 14:19:44.661685	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}"}	303729f1-67ea-4baf-94d8-b8081e8a9b4f	preorder	F002	990
ea297306-4cd1-4277-8b1b-717ee7544925	2019-10-08 14:19:44.663667	t	\N	450	29.4400000000000013	{"{\\"name\\":\\"Pack\\",\\"value\\":\\"B\\"}","{\\"name\\":\\"weight\\",\\"value\\":\\"10 kg\\"}"}	303729f1-67ea-4baf-94d8-b8081e8a9b4f	preorder	F003	990
bc380b5e-8e70-4d3b-b6f7-82ff9e267f13	2019-10-08 14:21:31.295506	t	2019-10-08 14:21:31	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"5 ตัว\\"}"}	7d2e5011-9f60-48c4-bc63-7f8c0e689935	order	E002	990
41338e1b-9e1d-4010-a91b-423392dbb712	2019-10-08 14:22:19.4453	t	2019-10-08 14:22:19	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"1 ตัว\\"}"}	4249fa47-87dd-4a06-a69e-307d00f78b7e	order	EE001	990
061cb998-208b-45e0-ac35-0278e7b9a9eb	2019-10-08 14:22:19.402946	t	2019-10-08 14:22:19	950	62.1499999999999986	{"{\\"name\\":\\"จำนวน\\",\\"value\\":\\"5 ตัว\\"}"}	4249fa47-87dd-4a06-a69e-307d00f78b7e	order	EE002	990
0caf9fe6-220a-4adc-b75a-618c18221056	2019-10-08 16:22:51.588661	t	\N	890	58.2199999999999989	{"{\\"name\\":\\"size\\",\\"value\\":\\"S\\"}"}	39d714f4-a2c5-41bc-bd9c-f1678872c1b8	preorder	S001	990
13eb15cd-f2e9-459a-b92f-85f113a0479b	2019-10-10 11:25:02.834017	t	2019-10-10 11:25:02	1505	98.1299999999999955	{"{\\"name\\":\\"ัสี\\",\\"value\\":\\"น้ำตาล\\"}","{\\"name\\":\\"ไซต์\\",\\"value\\":\\"XL\\"}"}	e29c982a-bade-4a88-95d9-15f9637f19ca	order	C001	990
7fc5cc27-14a8-4788-bb6f-28cd71636293	2019-10-10 15:25:26.483692	t	2019-10-10 15:25:26	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"L\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"black\\"}"}	c4e9ddf2-b951-4095-8ff6-7b4264c9d978	order	SUIT001	990
4b7b2fac-46b0-4fd9-b85d-036d1d80ce08	2019-10-10 15:25:26.26382	t	2019-10-10 15:25:26	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"white\\"}"}	c4e9ddf2-b951-4095-8ff6-7b4264c9d978	order	SUIT002	990
1eb1668d-f22d-4ee9-82c7-34122947b1be	2019-10-10 15:25:26.491942	t	2019-10-10 15:25:26	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"black\\"}"}	c4e9ddf2-b951-4095-8ff6-7b4264c9d978	order	SUIT003	990
a1c09ad7-39a0-4a14-915b-e94dd6dc0ae8	2019-10-10 11:14:07.680946	t	2019-10-10 11:14:07	500	19.629999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"เล็ก\\"}"}	ac61d01f-356f-4e1b-838e-0e44d6769d5f	order	KID003	990
2cea70d5-2deb-42e2-9ac2-74b36dc26038	2019-10-10 11:14:07.676945	t	2019-10-10 11:14:07	300	19.629999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"ใหญ่\\"}"}	ac61d01f-356f-4e1b-838e-0e44d6769d5f	order	KID001	990
9915228c-bde9-47ce-9b1d-7bf09dc26963	2019-10-10 11:14:07.626987	t	2019-10-10 11:14:07	400	19.629999999999999	{"{\\"name\\":\\"ขนาด\\",\\"value\\":\\"กลาง\\"}"}	ac61d01f-356f-4e1b-838e-0e44d6769d5f	order	KID002	990
5e587e2b-9c96-4c93-a8af-15a8c7b50d56	2019-10-10 15:28:08.804316	t	\N	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"white\\"}"}	4f1c32ae-fea6-40e8-b174-0bb9cc2c72b1	preorder	SUIT002	990
952c011a-a16d-4add-948c-91f25ce1d5cc	2019-10-10 15:28:08.805084	t	\N	5500	359.810000000000002	{"{\\"name\\":\\"size\\",\\"value\\":\\"XL\\"}","{\\"name\\":\\"color\\",\\"value\\":\\"black\\"}"}	4f1c32ae-fea6-40e8-b174-0bb9cc2c72b1	preorder	SUIT003	990
dddebc28-b306-4e3a-a0cf-79d977e9b6a6	2019-10-10 15:37:36.245554	t	2019-10-10 15:37:36	220	14.3900000000000006	{"{\\"name\\":\\"สายพันธุ์\\",\\"value\\":\\"สายน้ำผึ้ง\\"}"}	a73611cc-8207-46cb-afa3-178ad4223b4b	order	FR-ORG-001	990
966811bf-9da8-4de4-9314-c4cacd1ffd9d	2019-10-10 15:37:36.181285	t	2019-10-10 15:37:36	220	14.3900000000000006	{"{\\"name\\":\\"สายพันธุ์\\",\\"value\\":\\"เขียวหวาน\\"}"}	a73611cc-8207-46cb-afa3-178ad4223b4b	order	FR-ORG-002	990
154a260f-864d-4d89-a9ea-4f073b99a800	2019-10-10 15:41:23.768542	t	\N	220	14.3900000000000006	{"{\\"name\\":\\"สายพันธุ์\\",\\"value\\":\\"เขียวหวาน\\"}"}	e2078ad4-40a0-452c-afdd-36fd6227a6ff	preorder	FR-ORG-002	990
5eb8060c-41bf-4dd8-8bbb-ad0797e34074	2019-10-10 16:18:39.392872	t	\N	550	35.9799999999999969	{"{\\"name\\":\\"สี\\",\\"value\\":\\"เทา\\"}"}	d92ed07c-a262-4294-a472-74f58c3456ce	preorder	BAG-SIDE-001	990
\.


--
-- Data for Name: promptpay; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.promptpay (promptpayid, createdate, active, datemodify, promptpayname, promptpaynumber) FROM stdin;
54df9d83-c233-41ce-9fcf-5b35c704b7d8	2019-10-08 16:16:35	t	2019-10-10 12:54:51	\N	\N
7761e4bc-1498-40da-8069-f2c008590f3b	2019-10-08 14:15:04	t	2019-10-10 14:34:17	\N	\N
725bfb49-6e7a-4ce4-b6b9-4465263854d4	2019-10-10 15:33:10	t	2019-10-10 15:33:10		
1cf5bd0e-572f-4eac-afd4-bb21b1156018	2019-10-11 16:26:54	t	2019-10-11 16:26:54		
16406e9d-d45e-4c4b-b686-08c4917323fe	2019-10-11 16:33:08	f	2019-10-11 16:33:08	promtpay	64549864984
c4c39ef9-c262-4a0e-a056-237ceab03309	2019-10-11 16:40:53	t	2019-10-11 16:40:53	nielong	56284655461
b3ba79d9-1f94-4d22-8f00-99d6ce9eb150	2019-10-11 16:53:48	t	2019-10-11 16:53:48		
7c260b33-8ca8-4b40-8c1d-56979bc990c7	2019-10-10 15:08:56	t	2019-10-11 17:07:05		
db1c6712-697a-4f44-b20e-f3ead9906208	2019-10-11 17:09:04	t	2019-10-11 17:09:04	dede	89562562
ae7ed0cb-58a4-4f73-9483-9548ada94116	2019-10-11 17:09:47	t	2019-10-11 17:09:47	promtpay	64549864984
4b19788e-f518-4956-80fb-62464ab38ee1	2019-10-11 17:12:05	f	2019-10-11 17:12:05	promtpay	64549864984
33f7d2b2-70b9-4871-8442-e396b28a239a	2019-10-11 17:13:29	f	2019-10-11 17:13:29	promtpay	64549864984
9c528baa-f40b-4b50-9071-71aab0bc59d5	2019-10-11 17:14:48	f	2019-10-11 17:14:48	fvfv	8520785421
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
20a8d337-3bf2-414d-9da9-2319bfab7ef8	2019-10-11 17:12:05.35773	f	2019-10-11 17:12:05	ร้่นชุปเปอร์ก๋วยเตี๋ยว	NEWTORK	BKK	panakhon	30000	bankkok	0933347977	z@gmail.com	$2b$08$vA.523AWbD886cZwuU2Nj.XIuTcmE70oRpL3R8imb2JlugGD1R.yO	LKASDLKASNKD	\N	c611133c-48ee-473a-addb-a67d572fe7bc	4b19788e-f518-4956-80fb-62464ab38ee1
a9d108e1-5469-4a4c-b77b-3f920bb5ba32	2019-10-11 17:13:29.916222	f	2019-10-11 17:13:29	ร้่นชุปเปอร์ก๋วยเตี๋ยว	NEWTORK	BKK	panakhon	30000	bankkok	0933347977	p@gmail.com	$2b$08$HyHg4Y67d9wd.tuXnmOu..ndXfRAEJ7anXqFOpKAbjVAJ/SUjWgjq	LKASDLKASNKD	\N	7f3c9636-c786-4197-a5e7-679c45042706	33f7d2b2-70b9-4871-8442-e396b28a239a
a1daab42-0e48-4ea8-b1d7-a02da06ea4f8	2019-10-11 17:14:48.219733	t	2019-10-11 17:14:48	funfun	8552 tghnjmk	vgbhnj	vhgbnj	4512	vgbhnm	096352741	funfun@gmail.com	$2b$08$GM6xmMKDIrefETHdOqmqPu3r9fxwzegQeTrJKejx1Nc0EUfycbJPS	9856286542	picture-1570788888111.jpg	a6e0217b-9c26-42c8-bb4a-ee3b758fa810	9c528baa-f40b-4b50-9071-71aab0bc59d5
705f4aa2-d1d0-4550-ba18-3ae328f57673	2019-10-08 16:16:35.723479	t	2019-10-10 12:54:51	\N	\N	\N	\N	\N	\N	\N	\N	$2b$08$a3MHs8Kl57Nr4neWAEdPPunfMZlilfZTUsVFOPB1Lb.j689mxYOHW	456451285252	picture-1570526234641.jpg	8d47a16b-1244-4e81-a022-eb47526dd030	54df9d83-c233-41ce-9fcf-5b35c704b7d8
4cbd562f-8191-49e7-81ae-e7c85447ac2c	2019-10-10 15:33:10.504356	t	2019-10-10 15:33:10	Danik	101 พหลโยธิน 25	จตุจักร	จตุจักร	10900	กรุงเทพฯ	0957415253	daniel@gmail.com	$2b$08$z5td8GuZEPefDfw5wgtDt.tW88YBWc6Me09PR6K2Ius/2GizdcO0q	96352852566	picture-1570696390238.jpg	c596bb5f-76c2-4dfa-9af5-dc495f916e0c	725bfb49-6e7a-4ce4-b6b9-4465263854d4
eb27cc47-fd1b-455f-aae0-bb15db16fff3	2019-10-08 14:15:04.814668	t	2019-10-10 14:34:17	\N	\N	\N	\N	\N	\N	\N	\N	$2b$08$0XJ8pPLGhjBPEUBzjcfkKu6eO354zXyTIrnrgH3YtWWKUckAguD9C	895628945612	picture-1570518904495.jpg	604dc9b0-f9d4-4329-8873-e359bdede88a	7761e4bc-1498-40da-8069-f2c008590f3b
e868fb92-5348-4ce3-abbf-b706f02d04b2	2019-10-11 16:26:54.452551	t	2019-10-11 16:26:54	threestar	105 ถนนคนหล่อ	หนุ่มหล่อ	ทำอะไรก็หล่อ	101111	หล่อไปหมด	085284585	threestar@gmail.com	$2b$08$xDQaAX4rwMywxE5VEa3WQuYhsvoPTGmNDx5d.GioJDSBEDpmeh/mC	8565628562	picture-1570786014171.jpg	af93de31-2a81-4e42-8345-340f87a73973	1cf5bd0e-572f-4eac-afd4-bb21b1156018
5cf02ee0-25e1-429b-939c-a9452a7701d4	2019-10-11 16:40:53.177728	t	2019-10-11 16:40:53	NielOng	101 ถนนแฟนจ๋า	รักกัน	กอดกัน	101332	เคียงข้างกัน	096358247	nielong@gmail.com	$2b$08$JTbWdEAq8t2ejeM7saoL9.dT1DcF0BVj5R2PyfabtDOhua/fuBon2	5820852	picture-1570786853004.jpg	b993e44e-631e-43ee-b48d-e2cbfd26b2c5	c4c39ef9-c262-4a0e-a056-237ceab03309
c6336045-9a0b-4f35-b929-8e80e3f18986	2019-10-11 16:33:08.94076	f	2019-10-11 16:33:08	ร้่นชุปเปอร์ก๋วยเตี๋ยว	NEWTORK	BKK	panakhon	30000	bankkok	0933347977	j@gmail.com	$2b$08$Eqxt3YcRs8TRRIXmYdI9hexE9xbqUyMxDOvP/kQ.nkBx37P0cW7ZC	LKASDLKASNKD	\N	ce0cddd6-a630-4d61-b46e-efdc09535d11	16406e9d-d45e-4c4b-b686-08c4917323fe
8e37e4b0-ab24-4036-973a-1c7095526c3c	2019-10-11 16:53:48.224742	t	2019-10-11 16:53:48	Daniel.k	98  ถนนนีเวีย	วาสลิน	แก้วน้ำ	31222	มะขาม	09652852852	danielk@gmail.com	$2b$08$OVHXWV4YB75O8ezJI2aDI.oKqTu3gL4BeTT3mEliwCUIAnShiKOwa	852652471	picture-1570787628081.jpg	3155fbb2-85d1-4b22-9cde-2e157fc7c568	b3ba79d9-1f94-4d22-8f00-99d6ce9eb150
35af0d28-57f5-4eae-8075-513921404b00	2019-10-10 15:08:56.791801	t	2019-10-11 17:07:05	beabea	100 หมู่ 13	กุดน้ำใส	จัตุรัส	36130	ชัยภูมิ	0926633322	beabea@gmail.com	$2b$08$h2Gp5seJ/Y5XRiL0d3gGXuUkXdCEkg4bcPKaR7KI2P5Xr2JVucENG	9638528452	picture-1570788425417.jpg	f6896d33-652f-40c0-bb2b-c78076ea8ce5	7c260b33-8ca8-4b40-8c1d-56979bc990c7
d9a31e5c-96ac-448f-85f3-a956e98107e4	2019-10-11 17:09:04.446406	t	2019-10-11 17:09:04	DEDE	525 yhjk	hjmk,l	vgbhnjm	74512	ghjmk	8956230	dede@gmail.com	$2b$08$CdwmRiA9cIpyOCNZuxign.jDX1fN.O2DLM9PlC5crsdTym7t9khPi	89562396	\N	8abb4d69-cf1d-4860-8c23-e89d870ed69d	db1c6712-697a-4f44-b20e-f3ead9906208
37f7a663-0c02-42db-8eb8-78a0e5e09215	2019-10-11 17:09:47.449352	t	2019-10-11 17:09:47	ร้่นชุปเปอร์ก๋วยเตี๋ยว	NEWTORK	BKK	panakhon	30000	bankkok	0933347977	test45@gmail.com	$2b$08$yIyjp/Jli53WQGpfj8QIP.tRCv9oX8IDPA.dASHqixmfTes3okyRG	LKASDLKASNKD	\N	58d47651-3776-4689-8749-66e475869123	ae7ed0cb-58a4-4f73-9483-9548ada94116
\.


--
-- Data for Name: shipping; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.shipping (shipid, createdate, active, datemodify, shiptrackno, shipstatusid) FROM stdin;
a868b97f-c34f-4a1e-bdee-06dd57d49edb	2019-10-10 16:36:53.109333	t	\N	RE258852963TH	4
0be66b3a-278b-4b8a-b828-1d290eef4cdf	2019-10-11 10:57:48.228213	t	\N	EE258852963TH	4
733aa274-1129-4e75-a5be-cf3f28b1cd5c	2019-10-10 14:23:46.576787	t	\N	\N	4
3a3e1b86-8214-4e3c-bc51-8006fb3916cf	2019-10-11 11:35:26.432745	t	\N	\N	1
6e3613a1-b132-46e6-b7a0-bac6c126011d	2019-10-09 12:39:10.0146	t	\N	EW6558585TH	3
731dc4be-8e4b-45ea-b966-fb46c07e29b5	2019-10-09 12:40:47.204285	t	\N	RE6558585TH	3
4be2425e-8ec0-422e-8fae-3a97df192734	2019-10-09 12:40:06.503999	t	\N	RA685885TH	3
7b933e82-cfcc-4a79-9eac-c5336cba8a2e	2019-10-09 12:39:47.538956	t	\N	RP085852TH	3
7d5e899d-ef14-4396-9cce-e20dffac636e	2019-10-09 12:38:34.35649	t	\N	\N	4
790aad4f-e0f6-42e4-afac-b1a96a07da3b	2019-10-09 12:41:04.823523	t	\N	RR954852TH	3
8f01c290-0264-41bc-b34d-a459cfd122d6	2019-10-09 12:37:46.36655	t	\N	EU085852TH	3
50a33200-9202-4483-8f72-4538eb3a0275	2019-10-09 12:38:03.437035	t	\N	ED089572TH	3
c28e1887-d366-4d85-9734-e8cb6ac71633	2019-10-09 12:39:26.489808	t	\N	ES6553215TH	3
eae497d0-794c-47a8-9d4e-47f986aa030b	2019-10-11 11:37:13.536596	t	\N	EQ3216549878TH	4
eac88ee7-bb81-47a1-8528-df0c1bfb8c5e	2019-10-09 12:40:28.666469	t	\N	EP088552TH	3
8eb20963-9dee-43a7-b084-5fffe7f635cd	2019-10-09 12:38:52.134396	t	\N	WE56265564TH	3
6c5c0316-4bcb-4de7-9a2a-bedcfb78f897	2019-10-10 12:46:55.902803	t	\N	\N	1
a64bfef1-819d-4069-b380-9d2c0cf20e9c	2019-10-10 14:48:26.973621	t	\N	\N	1
cdd27490-a8b1-4e04-a48d-5af201b400b9	2019-10-11 12:21:52.971407	t	\N	\N	1
0ed7b1c5-859c-4143-a52a-dc84c97a1f08	2019-10-09 12:37:28.60992	t	\N	KLABSDKJBASD-ASKJLDBKASJD	4
0512cf30-2394-481b-8c0e-64310fe5ab2b	2019-10-11 12:23:00.98473	t	\N	RX852895895TH	4
8e3f6796-cb9e-4e86-ad0d-b0f6356d8a75	2019-10-11 11:40:46.846715	t	\N	EA123582397TH	4
a2b9d7b6-ba53-47af-9cf8-7d62a9e49045	2019-10-09 12:35:47.221742	t	\N	ABCDEFGHIJ	1
594ccb38-7f4a-4630-a800-f79169fe4ca4	2019-10-10 16:36:24.988515	t	\N	\N	1
4819a812-1e82-4038-b400-0d9d59459e38	2019-10-10 16:37:18.304252	t	\N	\N	1
\.


--
-- Data for Name: shippingstatus; Type: TABLE DATA; Schema: public; Owner: aom
--

COPY public.shippingstatus (shipstatusid, shippingstatusname, createdate, active, datemodify) FROM stdin;
2	รอตรวจสอบ การส่งสินค้า	2019-10-08 14:13:50.246282	t	\N
1	ยังไม่จัดส่งสินค้า	2019-10-08 14:13:50.21124	t	\N
3	ส่งสินค้าเรียบร้อยแล้ว	2019-10-08 14:13:50.270975	t	\N
4	รับสินค้าแล้ว	2019-10-08 16:18:43.073262	t	\N
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

