--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.12
-- Dumped by pg_dump version 9.5.12

-- Started on 2018-03-29 13:51:18 PDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2162 (class 1262 OID 16385)
-- Name: oliver; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE oliver WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_CA.UTF-8' LC_CTYPE = 'en_CA.UTF-8';


ALTER DATABASE oliver OWNER TO postgres;

\connect oliver

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12393)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2165 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 201 (class 1255 OID 16676)
-- Name: add_loan(integer, integer, money, text); Type: FUNCTION; Schema: public; Owner: oliver
--

CREATE FUNCTION public.add_loan(owner integer, sender integer, cost money, description text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO transactions (owner, sender, cost, description) VALUES (owner, sender, cost, description);
END;
$$;


ALTER FUNCTION public.add_loan(owner integer, sender integer, cost money, description text) OWNER TO oliver;

--
-- TOC entry 185 (class 1255 OID 16578)
-- Name: add_user(text, text); Type: FUNCTION; Schema: public; Owner: oliver
--

CREATE FUNCTION public.add_user(first_name text, last_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO users(first_name, last_name) VALUES (first_name, last_name);
END;
$$;


ALTER FUNCTION public.add_user(first_name text, last_name text) OWNER TO oliver;

--
-- TOC entry 199 (class 1255 OID 16672)
-- Name: get_all_transactions(); Type: FUNCTION; Schema: public; Owner: oliver
--

CREATE FUNCTION public.get_all_transactions() RETURNS TABLE(owner text, sender text, cost money, date date, description text)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY SELECT a.owner, b.sender, a.cost, a.date, a.description FROM ( SELECT transactionid, first_name as owner, transactions.cost, transactions.date, transactions.description FROM transactions INNER JOIN users ON transactions.owner = users.uid) AS a NATURAL JOIN ( SELECT transactionid, first_name as sender FROM users INNER JOIN transactions ON transactions.sender = users.uid) AS b WHERE a.cost::numeric > 0; END; $$;


ALTER FUNCTION public.get_all_transactions() OWNER TO oliver;

--
-- TOC entry 200 (class 1255 OID 16599)
-- Name: get_credit_data(integer); Type: FUNCTION; Schema: public; Owner: oliver
--

CREATE FUNCTION public.get_credit_data(searcheduser integer) RETURNS TABLE(owner text, sender text, cost money, date date, description text)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY SELECT a.owner, b.sender, a.cost, a.date, a.description FROM (
SELECT transactionid, first_name as owner, transactions.cost, transactions.date, transactions.description FROM
transactions INNER JOIN users ON transactions.owner = users.uid WHERE users.uid = searchedUser) AS a
NATURAL JOIN (
SELECT transactionid, first_name as sender FROM users INNER JOIN transactions ON transactions.sender = users.uid) AS b;
END; $$;


ALTER FUNCTION public.get_credit_data(searcheduser integer) OWNER TO oliver;

--
-- TOC entry 198 (class 1255 OID 16675)
-- Name: get_debt_data(integer); Type: FUNCTION; Schema: public; Owner: oliver
--

CREATE FUNCTION public.get_debt_data(searcheduser integer) RETURNS TABLE(owner text, sender text, cost money, date date, description text)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY SELECT a.owner, b.sender, -1*a.cost, a.date, a.description FROM (
SELECT transactionid, first_name as owner, transactions.cost, transactions.date, transactions.description FROM
transactions INNER JOIN users ON transactions.sender = users.uid WHERE users.uid = searchedUser) AS a
NATURAL JOIN (
SELECT transactionid, first_name as sender FROM users INNER JOIN transactions ON transactions.owner = users.uid) AS b;
END;
$$;


ALTER FUNCTION public.get_debt_data(searcheduser integer) OWNER TO oliver;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 184 (class 1259 OID 16649)
-- Name: transactions; Type: TABLE; Schema: public; Owner: oliver
--

CREATE TABLE public.transactions (
    transactionid integer NOT NULL,
    owner integer NOT NULL,
    sender integer NOT NULL,
    cost money NOT NULL,
    date date DEFAULT ('now'::text)::date NOT NULL,
    description text
);


ALTER TABLE public.transactions OWNER TO oliver;

--
-- TOC entry 183 (class 1259 OID 16647)
-- Name: transactions_transactionid_seq; Type: SEQUENCE; Schema: public; Owner: oliver
--

CREATE SEQUENCE public.transactions_transactionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transactions_transactionid_seq OWNER TO oliver;

--
-- TOC entry 2166 (class 0 OID 0)
-- Dependencies: 183
-- Name: transactions_transactionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oliver
--

ALTER SEQUENCE public.transactions_transactionid_seq OWNED BY public.transactions.transactionid;


--
-- TOC entry 182 (class 1259 OID 16638)
-- Name: users; Type: TABLE; Schema: public; Owner: oliver
--

CREATE TABLE public.users (
    uid integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL
);


ALTER TABLE public.users OWNER TO oliver;

--
-- TOC entry 181 (class 1259 OID 16636)
-- Name: users_uid_seq; Type: SEQUENCE; Schema: public; Owner: oliver
--

CREATE SEQUENCE public.users_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_uid_seq OWNER TO oliver;

--
-- TOC entry 2167 (class 0 OID 0)
-- Dependencies: 181
-- Name: users_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oliver
--

ALTER SEQUENCE public.users_uid_seq OWNED BY public.users.uid;


--
-- TOC entry 2031 (class 2604 OID 16652)
-- Name: transactionid; Type: DEFAULT; Schema: public; Owner: oliver
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transactionid SET DEFAULT nextval('public.transactions_transactionid_seq'::regclass);


--
-- TOC entry 2030 (class 2604 OID 16641)
-- Name: uid; Type: DEFAULT; Schema: public; Owner: oliver
--

ALTER TABLE ONLY public.users ALTER COLUMN uid SET DEFAULT nextval('public.users_uid_seq'::regclass);


--
-- TOC entry 2156 (class 0 OID 16649)
-- Dependencies: 184
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: oliver
--

INSERT INTO public.transactions VALUES (1, 1, 2, '$30.00', '2018-11-13', 'T-shirt');
INSERT INTO public.transactions VALUES (2, 1, 3, '$3.00', '2018-12-25', 'Icecream Sandwich');
INSERT INTO public.transactions VALUES (3, 3, 2, '$14.00', '2018-03-14', 'Pie');
INSERT INTO public.transactions VALUES (4, 2, 1, '$25.00', '2018-01-01', '2018 glasses');
INSERT INTO public.transactions VALUES (5, 3, 2, '$45.00', '2018-03-26', 'Video Game');
INSERT INTO public.transactions VALUES (6, 3, 2, '$80.00', '2018-03-26', 'Super Mario Odyssey');
INSERT INTO public.transactions VALUES (7, 8, 1, '$25.00', '2018-03-26', 'REDACTED');
INSERT INTO public.transactions VALUES (9, 1, 2, '$10.00', '2018-03-26', 'Test');
INSERT INTO public.transactions VALUES (11, 3, 1, '$15.00', '2018-03-26', 'Humble Bundle');
INSERT INTO public.transactions VALUES (10, 3, 11, '$500.00', '2018-03-26', 'Window repair');
INSERT INTO public.transactions VALUES (13, 8, 4, '$25.00', '2018-03-27', 'Also test');
INSERT INTO public.transactions VALUES (14, 18, 11, '$5,000.00', '2018-03-29', 'Academic Endowment');


--
-- TOC entry 2168 (class 0 OID 0)
-- Dependencies: 183
-- Name: transactions_transactionid_seq; Type: SEQUENCE SET; Schema: public; Owner: oliver
--

SELECT pg_catalog.setval('public.transactions_transactionid_seq', 14, true);


--
-- TOC entry 2154 (class 0 OID 16638)
-- Dependencies: 182
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: oliver
--

INSERT INTO public.users VALUES (1, 'Oliver', 'Tonnesen');
INSERT INTO public.users VALUES (2, 'Mackenzie', 'Cooper');
INSERT INTO public.users VALUES (3, 'Victor', 'Sun');
INSERT INTO public.users VALUES (4, 'Matthew', 'Holmes');
INSERT INTO public.users VALUES (7, 'Cougar', 'Oakes');
INSERT INTO public.users VALUES (8, 'Frederick', 'Odiase');
INSERT INTO public.users VALUES (9, 'John', 'Doe');
INSERT INTO public.users VALUES (10, 'Peter', 'Parker');
INSERT INTO public.users VALUES (11, 'Tony', 'Stark');
INSERT INTO public.users VALUES (12, 'Bruce', 'Banner');
INSERT INTO public.users VALUES (13, 'Clark', 'Kent');
INSERT INTO public.users VALUES (14, 'Black', 'Widow');
INSERT INTO public.users VALUES (15, 'Hawk', 'Eye');
INSERT INTO public.users VALUES (16, 'Test', 'ing''); SELECT * FROM users;''');
INSERT INTO public.users VALUES (17, '''', '''');
INSERT INTO public.users VALUES (18, 'Bill', 'Bird');
INSERT INTO public.users VALUES (19, 'Barack', 'Obama');


--
-- TOC entry 2169 (class 0 OID 0)
-- Dependencies: 181
-- Name: users_uid_seq; Type: SEQUENCE SET; Schema: public; Owner: oliver
--

SELECT pg_catalog.setval('public.users_uid_seq', 19, true);


--
-- TOC entry 2036 (class 2606 OID 16658)
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: oliver
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transactionid);


--
-- TOC entry 2034 (class 2606 OID 16646)
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: oliver
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- TOC entry 2037 (class 2606 OID 16659)
-- Name: transactions_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: oliver
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_owner_fkey FOREIGN KEY (owner) REFERENCES public.users(uid);


--
-- TOC entry 2038 (class 2606 OID 16664)
-- Name: transactions_sender_fkey; Type: FK CONSTRAINT; Schema: public; Owner: oliver
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_sender_fkey FOREIGN KEY (sender) REFERENCES public.users(uid);


--
-- TOC entry 2164 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2018-03-29 13:51:18 PDT

--
-- PostgreSQL database dump complete
--

