import os
import psycopg2
from psycopg2.extras import RealDictCursor
import json
from flask import Flask, jsonify, render_template, request, redirect, make_response

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
    if request.method == 'POST':
        with conn.cursor() as cur:
            fName = request.form['first_name']
            lName = request.form['last_name']
            cur.execute('SELECT add_user(%s, %s)', (fName, lName))
            conn.commit()
            resp = make_response(redirect('/'))
            if(cur.query == "SELECT add_user('', '')"):
                return resp
            resp.set_cookie('userAddSuccess', value='True')
            return resp
    resp = make_response(render_template('main.html', userAddSuccess=request.cookies.get('userAddSuccess')))
    resp.set_cookie('userAddSuccess', value='')
    return resp

@app.route('/data')
def getData():
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM users ORDER BY uid;')
        d = cur.fetchall()
        return jsonify(d)

@app.route('/data/<int:id>')
def getUserData(id):
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM get_credit_data(%d)' % id)
        credit = cur.fetchall()
        cur.execute('SELECT * FROM get_debt_data(%d)' % id)
        debt = cur.fetchall()
        return render_template('transaction_list.html', credList=credit, debtList=debt, credEmpty=len(credit)==0, debtEmpty=len(debt)==0)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
