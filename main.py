import os
import psycopg2
import json
from flask import Flask, jsonify, render_template

filepath = 'static/data.json'
DATABASE_URL = os.environ['DATABASE_URL']
print(DATABASE_URL)

conn = psycopg2.connect(DATABASE_URL, sslmode='require')

cur = conn.cursor()
'''
cur.execute('DROP TABLE IF EXISTS test;')
cur.execute('CREATE SEQUENCE user_id_seq;')
cur.execute('CREATE TABLE test (user_id smallint NOT NULL DEFAULT nextval(user_id_seq), name varchar(40), address varchar(40));')
cur.execute('ALTER SEQUENCE user_id_seq OWNED BY user.user_id;')
cur.execute("INSERT INTO test (name, address) VALUES ('Oliver', '6431 Riverstone Drive');")
cur.close()
'''
app = Flask(__name__)

@app.route('/data')
def index():
    with open(filepath, 'r') as f:
        d = json.load(f)
        return jsonify(d)

@app.route('/')
def main():
    return render_template('main.html')

@app.route('/test')
def test():
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM test;")
        return cur.fetchone()

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
