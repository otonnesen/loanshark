create table transactions
(
  transactionid serial                               not null
    constraint transactions_pkey
    primary key,
  owner         text                                 not null
    constraint owner
    references users,
  sender        text                                 not null
    constraint sender
    references users,
  cost          numeric(7, 2)                        not null,
  date          date default ('now' :: text) :: date not null,
  description   text,
  confirmed     boolean default false                not null,
  addedby       text                                 not null
    constraint addedby
    references users,
  complete      boolean default false                not null
);

create unique index transactions_transactionid_uindex
  on transactions (transactionid);

create table users
(
  username  text not null
    constraint users_pkey
    primary key,
  password  text not null,
  firstname text not null,
  lastname  text not null
);

create unique index users_username_uindex
  on users (username);

CREATE EXTENSION pgcrypto;

create function add_loan(owner text, sender text, cost numeric, description text, addedby text)
  returns void
language plpgsql
as $$
BEGIN
  INSERT INTO transactions (owner, sender, cost, description, addedby)
  VALUES (owner, sender, cost, description, addedby);
END;
$$;

create function confirm_transaction(tid integer)
  returns void
language plpgsql
as $$
BEGIN
  UPDATE transactions SET confirmed='t' WHERE transactions.transactionid = tid;
END;
$$;

create function createuser(username text, password text, firstname text, lastname text)
  returns void
language plpgsql
as $$
BEGIN
  INSERT INTO users (username, password, firstname, lastname)
  VALUES (username, crypt(password, gen_salt('bf')), firstname, lastname);
END;
$$;

create function validate(uname text, pass text)
  returns boolean
language plpgsql
as $$
BEGIN
RETURN EXISTS (SELECT * FROM users WHERE username=uname AND password=crypt(pass, password));
END;
$$;

create function get_all_transactions()
  returns TABLE(transactionid integer, owner text, sender text, cost numeric, date date, description text, confirmed boolean, complete boolean)
language plpgsql
as $$
BEGIN
  RETURN QUERY SELECT
                 a.transactionid,
                 a.owner,
                 b.sender,
                 a.cost,
                 a.date,
                 a.description,
                 a.confirmed,
                 a.complete
               FROM (SELECT
                       transactions.transactionid,
                       firstname AS owner,
                       transactions.cost,
                       transactions.date,
                       transactions.description,
                       transactions.confirmed,
                       transactions.complete
                     FROM transactions
                       INNER JOIN users ON transactions.owner = users.username) AS a NATURAL JOIN (SELECT
                                                                                                     transactions.transactionid,
                                                                                                     firstname AS sender
                                                                                                   FROM users
                                                                                                     INNER JOIN
                                                                                                     transactions
                                                                                                       ON
                                                                                                         transactions.sender
                                                                                                         =
                                                                                                         users.username) AS b;
END;
$$;

create function get_credit_data_confirmed(searcheduser text)
  returns TABLE(transactionid integer, owner text, sender text, cost numeric, date date, description text, confirmed boolean, complete boolean, addedby text)
language plpgsql
as $$
BEGIN
  RETURN QUERY SELECT
                 a.transactionid,
                 a.owner,
                 b.sender,
                 a.cost,
                 a.date,
                 a.description,
                 a.confirmed,
                 a.complete,
                 a.addedby
               FROM (
                      SELECT
                        transactions.transactionid,
                        users.firstname AS owner,
                        transactions.cost,
                        transactions.date,
                        transactions.description,
                        transactions.confirmed,
                        transactions.complete,
                        transactions.addedby
                      FROM
                        transactions
                        INNER JOIN users ON transactions.owner = users.username
                      WHERE users.username = searchedUser) AS a
                 INNER JOIN (
                              SELECT
                                transactions.transactionid,
                                firstname AS sender
                              FROM users
                                INNER JOIN transactions ON transactions.sender = users.username) AS b
                   ON a.transactionid = b.transactionid WHERE a.confirmed;
END;
$$;

create function get_credit_data_unconfirmed(searcheduser text)
  returns TABLE(transactionid integer, owner text, sender text, cost numeric, date date, description text, confirmed boolean, complete boolean, addedby text)
language plpgsql
as $$
BEGIN
  RETURN QUERY SELECT
                 a.transactionid,
                 a.owner,
                 b.sender,
                 a.cost,
                 a.date,
                 a.description,
                 a.confirmed,
                 a.complete,
                 a.addedby
               FROM (
                      SELECT
                        transactions.transactionid,
                        firstname AS owner,
                        transactions.cost,
                        transactions.date,
                        transactions.description,
                        transactions.confirmed,
                        transactions.complete,
                        transactions.addedby
                      FROM
                        transactions
                        INNER JOIN users ON transactions.owner = users.username
                      WHERE users.username = searchedUser) AS a
                 INNER JOIN (
                              SELECT
                                transactions.transactionid,
                                firstname AS sender
                              FROM users
                                INNER JOIN transactions ON transactions.sender = users.username) AS b
                   ON a.transactionid = b.transactionid WHERE NOT a.confirmed;
END;
$$;

create function get_debt_data_confirmed(searcheduser text)
  returns TABLE(transactionid integer, owner text, sender text, cost numeric, date date, description text, confirmed boolean, complete boolean, addedby text)
language plpgsql
as $$
BEGIN
  RETURN QUERY SELECT
                 a.transactionid,
                 a.owner,
                 b.sender,
                 -1 * a.cost,
                 a.date,
                 a.description,
                 a.confirmed,
                 a.complete,
                 a.addedby
               FROM (
                      SELECT
                        transactions.transactionid,
                        firstname AS owner,
                        transactions.cost,
                        transactions.date,
                        transactions.description,
                        transactions.confirmed,
                        transactions.complete,
                        transactions.addedby
                      FROM
                        transactions
                        INNER JOIN users ON transactions.sender = users.username
                      WHERE users.username = searchedUser) AS a
                 INNER JOIN (
                              SELECT
                                transactions.transactionid,
                                firstname AS sender
                              FROM users
                                INNER JOIN transactions ON transactions.owner = users.username) AS b
                   ON a.transactionid = b.transactionid
               WHERE a.confirmed;
END;
$$;

create function get_debt_data_unconfirmed(searcheduser text)
  returns TABLE(transactionid integer, owner text, sender text, cost numeric, date date, description text, confirmed boolean, complete boolean, addedby text)
language plpgsql
as $$
BEGIN
  RETURN QUERY SELECT
                 a.transactionid,
                 a.owner,
                 b.sender,
                 -1 * a.cost,
                 a.date,
                 a.description,
                 a.confirmed,
                 a.complete,
                 a.addedby
               FROM (
                      SELECT
                        transactions.transactionid,
                        firstname AS owner,
                        transactions.cost,
                        transactions.date,
                        transactions.description,
                        transactions.confirmed,
                        transactions.complete,
                        transactions.addedby
                      FROM
                        transactions
                        INNER JOIN users ON transactions.sender = users.username
                      WHERE users.username = searchedUser) AS a
                 INNER JOIN (
                              SELECT
                                transactions.transactionid,
                                firstname AS sender
                              FROM users
                                INNER JOIN transactions ON transactions.owner = users.username) AS b
                   ON a.transactionid = b.transactionid
               WHERE NOT a.confirmed;
END;
$$;


