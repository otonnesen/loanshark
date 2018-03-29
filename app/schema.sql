-- Sequence: public.transactionid_seq

-- DROP SEQUENCE public.transactionid_seq;

CREATE SEQUENCE public.transactionid_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 2147483647
  START 2
  CACHE 1;
ALTER TABLE public.transactionid_seq
  OWNER TO oliver;
-- Sequence: public.uid_seq

-- DROP SEQUENCE public.uid_seq;

CREATE SEQUENCE public.uid_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 2147483647
  START 4
  CACHE 1;
ALTER TABLE public.uid_seq
  OWNER TO oliver;
-- Table: public.users

-- DROP TABLE public.users;

CREATE TABLE public.users
(
  uid integer NOT NULL DEFAULT nextval('uid_seq'::regclass),
  first_name text NOT NULL,
  last_name text NOT NULL,
  CONSTRAINT users2_pkey PRIMARY KEY (uid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.users
  OWNER TO oliver;

-- Table: public.transactions

-- DROP TABLE public.transactions;

CREATE TABLE public.transactions
(
  transactionid integer NOT NULL DEFAULT nextval('transactionid_seq'::regclass),
  owner integer NOT NULL,
  sender integer NOT NULL,
  cost money NOT NULL,
  date date NOT NULL DEFAULT ('now'::text)::date,
  description text,
  CONSTRAINT transactions2_pkey PRIMARY KEY (transactionid),
  CONSTRAINT transactions2_owner_fkey FOREIGN KEY (owner)
      REFERENCES public.users (uid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT transactions2_sender_fkey FOREIGN KEY (sender)
      REFERENCES public.users (uid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.transactions
  OWNER TO oliver;
