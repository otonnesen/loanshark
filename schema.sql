-- Table: public.transactions
-- DROP TABLE public.transactions;

CREATE TABLE public.transactions
(
  uid integer NOT NULL,
  cost money NOT NULL,
  date date NOT NULL DEFAULT ('now'::text)::date,
  description text
)
WITH (
  OIDS=FALSE
)
ALTER TABLE public.transactions
  OWNER TO oliver;

-- Table: public.users

-- DROP TABLE public.users;

CREATE TABLE public.users
(
  uid integer NOT NULL DEFAULT nextval('uid_seq'::regclass),
  first_name text NOT NULL,
  last_name text NOT NULL
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.users
  OWNER TO oliver;

