import os
import psycopg2
import json
from flask import Flask, jsonify, render_template

filepath = 'static/data.json'

try:
    DATABASE_URL = os.environ['DATABASE_URL']
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
except LookupError:
    DATABASE_URL = 'postgresql://localhost:5432'
    conn = psycopg2.connect(DATABASE_URL, sslmode='require', password='Redbrick09')


cur = conn.cursor()

cur.execute("CREATE SEQUENCE test_uid_seq INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;")
cur.execute("CREATE TABLE test (uid integer NOT NULL DEFAULT nextval('test_uid_seq'::regclass), first_name text, last_name text);")
cur.execute("INSERT INTO test (first_name, last_name) VALUES ('Oliver', 'Tonnesen'), ('Mackenzie', 'Cooper'), ('Matthew', 'Holmes'), ('Victor', 'Sun');")
cur.close()

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
        return str(cur.fetchall())

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
