import os
import psycopg2
from psycopg2.extras import RealDictCursor
import json
from flask import Flask, jsonify, render_template

filepath = 'static/data.json'

try:
    DATABASE_URL = os.environ['DATABASE_URL']
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
except LookupError:
    #conn = psycopg2.connect(dbname='oliver', user='oliver', password='Redbrick09')
    conn = psycopg2.connect(dbname='oliver', user='oliver', password='Redbrick09')


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
    s = ""
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute("SELECT * FROM users NATURAL JOIN transactions;")
        d = cur.fetchall()
        return jsonify(d)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
