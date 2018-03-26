SELECT owner, sender, cost, date, description FROM (
	SELECT transactionid, first_name as owner, cost, date, description FROM
	transactions INNER JOIN users ON transactions.owner = users.uid
) as a
NATURAL JOIN (
	SELECT transactionid, first_name as sender FROM
	users INNER JOIN transactions ON transactions.sender = users.uid
) as b;
