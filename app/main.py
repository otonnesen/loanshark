import os
import psycopg2
from psycopg2.extras import RealDictCursor
import json
from flask import Flask, jsonify, render_template, request

filepath = 'static/data.json'

try:
    DATABASE_URL = os.environ['DATABASE_URL']
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
except LookupError:
    # Local env
    conn = psycopg2.connect(dbname='oliver', user='oliver', password='Redbrick09')


app = Flask(__name__)

@app.route('/old')
def index():
    with open(filepath, 'r') as f:
        d = json.load(f)
        return jsonify(d)

@app.route('/', methods=['GET', 'POST'])
def main():
    return render_template('main.html')

@app.route('/addUser', methods=['POST'])
def addUser():
    with conn.cursor() as cur:
        fName = request.form['first_name']
        lName = request.form['last_name']
        cur.execute('SELECT add_user(%s, %s)', (fName, lName))
        return render_template('success.html')

@app.route('/data')
def getData():
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM users;')
        d = cur.fetchall()
        return jsonify(d)

@app.route('/data/<int:id>')
def getUserData(id):
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM get_table_data(%d)' % id)
        d = cur.fetchall()
        return render_template('transaction_list.html', transaction_list=d)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
