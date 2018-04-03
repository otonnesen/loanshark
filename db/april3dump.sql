--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3
-- Dumped by pg_dump version 10.3

-- Started on 2018-04-03 16:09:53

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2859 (class 0 OID 24980)
-- Dependencies: 201
-- Data for Name: test; Type: TABLE DATA; Schema: public; Owner: oliver
--

COPY public.test (username, password) FROM stdin;
test	$2a$06$ZiIPd32JCNdLaM8UN19k6ewblZP72SjdCWakhM3xpIveL9aSaG5XC
\.


--
-- TOC entry 2855 (class 0 OID 16816)
-- Dependencies: 197
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: oliver
--

COPY public.transactions (transactionid, owner, sender, cost, date, description) FROM stdin;
1	1	2	30.00	2018-11-13	T-shirt
2	1	3	3.00	2018-12-25	Icecream Sandwich
3	3	2	14.00	2018-03-14	Pie
4	2	1	25.00	2018-01-01	2018 glasses
5	3	2	45.00	2018-03-26	Video Game
6	3	2	80.00	2018-03-26	Super Mario Odyssey
7	8	1	25.00	2018-03-26	REDACTED
9	1	2	10.00	2018-03-26	Test
11	3	1	15.00	2018-03-26	Humble Bundle
10	3	11	500.00	2018-03-26	Window repair
13	8	4	25.00	2018-03-27	Also test
15	1	1	1.00	2018-03-30	
16	22	1	10000.00	2018-03-31	Money for a new N scale Locomotive
18	1	2	3.00	2018-04-01	test
19	2	1	1.00	2018-04-01	1
20	3	4	5.00	2018-04-01	6
14	18	11	5000.00	2018-03-29	Research Endowment
\.


--
-- TOC entry 2857 (class 0 OID 16825)
-- Dependencies: 199
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: oliver
--

COPY public.users (uid, first_name, last_name, username, password) FROM stdin;
1	Oliver	Tonnesen	\N	\N
2	Mackenzie	Cooper	\N	\N
3	Victor	Sun	\N	\N
4	Matthew	Holmes	\N	\N
7	Cougar	Oakes	\N	\N
8	Frederick	Odiase	\N	\N
9	John	Doe	\N	\N
10	Peter	Parker	\N	\N
11	Tony	Stark	\N	\N
12	Bruce	Banner	\N	\N
13	Clark	Kent	\N	\N
14	Black	Widow	\N	\N
15	Hawk	Eye	\N	\N
16	Test	ing'); SELECT * FROM users;'	\N	\N
17	'	'	\N	\N
18	Bill	Bird	\N	\N
19	Barack	Obama	\N	\N
20	Calvin	Broadus	\N	\N
21	Hulk	Hogan	\N	\N
22	Steve	Tonnesen	\N	\N
23	Oliver	Tonnesen	\N	\N
24	Abraham	Lincoln	\N	\N
25	testing1	testing2	\N	\N
\.


--
-- TOC entry 2871 (class 0 OID 0)
-- Dependencies: 198
-- Name: transactions_transactionid_seq; Type: SEQUENCE SET; Schema: public; Owner: oliver
--

SELECT pg_catalog.setval('public.transactions_transactionid_seq', 20, true);


--
-- TOC entry 2872 (class 0 OID 0)
-- Dependencies: 200
-- Name: users_uid_seq; Type: SEQUENCE SET; Schema: public; Owner: oliver
--

SELECT pg_catalog.setval('public.users_uid_seq', 25, true);


SET default_tablespace = '';

--
-- TOC entry 2729 (class 2606 OID 16836)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: oliver
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transactionid);


--
-- TOC entry 2731 (class 2606 OID 16838)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: oliver
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- TOC entry 2732 (class 2606 OID 16839)
-- Name: transactions transactions_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: oliver
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_owner_fkey FOREIGN KEY (owner) REFERENCES public.users(uid);


--
-- TOC entry 2733 (class 2606 OID 16844)
-- Name: transactions transactions_sender_fkey; Type: FK CONSTRAINT; Schema: public; Owner: oliver
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_sender_fkey FOREIGN KEY (sender) REFERENCES public.users(uid);


-- Completed on 2018-04-03 16:09:54

--
-- PostgreSQL database dump complete
--

