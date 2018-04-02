INSERT INTO test VALUES (crypt('password', gen_salt('bf')));
SELECT * FROM test WHERE pw IS NOT NULL AND pw = crypt('password', pw);
SELECT EXISTS (SELECT * FROM test WHERE username='test' AND password=crypt('test', password));
