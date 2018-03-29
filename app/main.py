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
    resp = make_response(render_template('main.html', userAddSuccess=request.cookies.get('userAddSuccess'), loanAddSuccess=request.cookies.get('loanAddSuccess')))
    resp.set_cookie('userAddSuccess', value='')
    resp.set_cookie('loanAddSuccess', value='')
    return resp

@app.route('/addUser', methods=['POST'])
def addUser():
    with conn.cursor() as cur:
        fName = request.form['first_name']
        lName = request.form['last_name']
        resp = make_response(redirect('/'))
        if(fName=='' or lName==''):
            return resp
        cur.execute('SELECT add_user(%s, %s)', (fName, lName))
        conn.commit()
        resp.set_cookie('userAddSuccess', value='True')
        return resp

@app.route('/addLoan', methods=['POST'])
def addLoan():
    with conn.cursor() as cur:
        owner = request.form['owner']
        sender = request.form['sender']
        cost = request.form['cost']
        description = request.form['description']
        resp = make_response(redirect('/'))
        if(owner=='' or sender=='' or cost==''):
            return resp
        cur.execute('SELECT add_loan(%s, %s, %s, %s)', (int(owner), int(sender), cost, description))
        conn.commit()
        resp.set_cookie('loanAddSuccess', value='True')
        return resp

@app.route('/data/transactions', methods=['GET'])
def getTransactionData():
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM get_all_transactions();')
        d = cur.fetchall()
        return jsonify(d)

@app.route('/data/users', methods=['GET'])
def getUserData():
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM users;')
        d = cur.fetchall()
        return jsonify(d) 
@app.route('/data/<int:id>')
def getIdData(id):
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM get_credit_data(%s)', (id,))

        credit = cur.fetchall()
        cur.execute('SELECT * FROM get_debt_data(%s)', (id,))
        debt = cur.fetchall()
        return render_template('transaction_list.html', credList=credit, debtList=debt, credEmpty=len(credit)==0, debtEmpty=len(debt)==0)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
