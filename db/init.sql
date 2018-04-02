create table if not exists users
(
  uid        serial not null
    constraint users_pkey
    primary key,
  first_name text   not null,
  last_name  text   not null
);

create table if not exists transactions
(
  transactionid serial                               not null
    constraint transactions_pkey
    primary key,
  owner         integer                              not null
    constraint transactions_owner_fkey
    references users,
  sender        integer                              not null
    constraint transactions_sender_fkey
    references users,
  cost          numeric(7, 2)                        not null,
  date          date default ('now' :: text) :: date not null,
  description   text
);

create or replace function add_user(first_name text, last_name text)
  returns void
language plpgsql
as $$
BEGIN
  INSERT INTO users (first_name, last_name) VALUES (first_name, last_name);
END;
$$;

create or replace function get_credit_data(searcheduser integer)
  returns TABLE(owner text, sender text, cost numeric, date date, description text)
language plpgsql
as $$
BEGIN
  RETURN QUERY SELECT
                 a.owner,
                 b.sender,
                 a.cost,
                 a.date,
                 a.description
               FROM (
                      SELECT
                        transactionid,
                        first_name AS owner,
                        transactions.cost,
                        transactions.date,
                        transactions.description
                      FROM
                        transactions
                        INNER JOIN users ON transactions.owner = users.uid
                      WHERE users.uid = searchedUser) AS a
                 NATURAL JOIN (
                                SELECT
                                  transactionid,
                                  first_name AS sender
                                FROM users
                                  INNER JOIN transactions ON transactions.sender = users.uid) AS b;
END;
$$;

create or replace function get_debt_data(searcheduser integer)
  returns TABLE(owner text, sender text, cost numeric, date date, description text)
language plpgsql
as $$
BEGIN
  RETURN QUERY SELECT
                 a.owner,
                 b.sender,
                 -1 * a.cost,
                 a.date,
                 a.description
               FROM (
                      SELECT
                        transactionid,
                        first_name AS owner,
                        transactions.cost,
                        transactions.date,
                        transactions.description
                      FROM
                        transactions
                        INNER JOIN users ON transactions.sender = users.uid
                      WHERE users.uid = searchedUser) AS a
                 NATURAL JOIN (
                                SELECT
                                  transactionid,
                                  first_name AS sender
                                FROM users
                                  INNER JOIN transactions ON transactions.owner = users.uid) AS b;
END;
$$;

create or replace function add_loan(owner integer, sender integer, cost numeric, description text)
  returns void
language plpgsql
as $$
BEGIN
  INSERT INTO transactions (owner, sender, cost, description) VALUES (owner, sender, cost, description);
END;
$$;

create or replace function get_all_transactions()
  returns TABLE(transactionid integer, owner text, sender text, cost numeric, date date, description text)
language plpgsql
as $$
BEGIN
  RETURN QUERY SELECT
                 a.transactionid,
                 a.owner,
                 b.sender,
                 a.cost,
                 a.date,
                 a.description
               FROM (SELECT
                       transactions.transactionid,
                       first_name AS owner,
                       transactions.cost,
                       transactions.date,
                       transactions.description
                     FROM transactions
                       INNER JOIN users ON transactions.owner = users.uid) AS a NATURAL JOIN (SELECT
                                                                                                transactions.transactionid,
                                                                                                first_name AS sender
                                                                                              FROM users
                                                                                                INNER JOIN transactions
                                                                                                  ON transactions.sender
                                                                                                     = users.uid) AS b
               WHERE a.cost :: NUMERIC > 0;
END;
$$;


