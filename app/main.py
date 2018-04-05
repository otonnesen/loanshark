import os
import psycopg2
from psycopg2.extras import RealDictCursor
import json
# Replaces flask.jsonify to work with Decimal type
import simplejson
from flask import Flask, jsonify, render_template, request, redirect, make_response, flash
from flask_login import LoginManager

try:
    DATABASE_URL = os.environ['DATABASE_URL']
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
except LookupError:
    # Local env
    conn = psycopg2.connect(host='localhost', dbname='loanshark', user='oliver', password=os.environ['pw'])


app = Flask(__name__)
app.secret_key = 'thisismyseceretkey'

@app.route('/', methods=['GET'])
def main():
    flash('test')
    return render_template('main.html')

# @app.route('/addUser', methods=['POST'])
# def addUser():
#     with conn.cursor() as cur:
#         fName = request.form['first_name']
#         lName = request.form['last_name']
#         cur.execute('SELECT add_user(%s, %s)', (fName, lName))
#         conn.commit()
#         resp = make_response(redirect('/'))
#         return resp

# @app.route('/addLoan', methods=['POST'])
# def addLoan():
#     with conn.cursor() as cur:
#         owner = request.form['owner']
#         sender = request.form['sender']
#         cost = request.form['cost']
#         description = request.form['description']
#         resp = make_response(redirect('/'))
#         if(owner==sender):
#             return resp
#         cur.execute('SELECT add_loan(%s, %s, %s, %s)', (int(owner), int(sender), cost, description))
#         conn.commit()
#         return resp

@app.route('/data/transactions', methods=['GET'])
def getTransactionData():
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM get_all_transactions() ORDER BY transactionid;')
        d = cur.fetchall()
        return jsonify(d)

@app.route('/data/users', methods=['GET'])
def getUserData():
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM users;')
        d = cur.fetchall()
        return jsonify(d) 

@app.route('/data/<string:id>')
def getIdData(id):
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM get_credit_data(%s)', (id,))
        credit = cur.fetchall()
        cur.execute('SELECT * FROM get_debt_data(%s)', (id,))
        debt = cur.fetchall()
        return render_template('transaction_list.html', credList=credit, debtList=debt)

@app.route('/login')
def login():
    with conn.cursor() as cur:
        return render_template('login.html')

@app.route('/create')
def create():
    with conn.cursor() as cur:
        return render_template('create.html')

# @app.route('/test', methods=['POST'])
# def test():
#     username = request.get_json()['username']
#     password = request.get_json()['password']
#     with conn.cursor(cursor_factory=RealDictCursor) as cur:
#         cur.execute('SELECT EXISTS (SELECT * FROM test WHERE username=%s AND password=crypt(%s, password));', (username, password))
#         d = cur.fetchone()
#         return jsonify(d)

@app.route('/checkCred', methods=['POST'])
def checkCred():
    username = request.get_json()['username']
    password = request.get_json()['password']
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT validate(%s, %s);', (username, password))
        d = cur.fetchone()
        return jsonify(d)

@app.route('/createUser', methods=['POST'])
def createUser():
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        username = request.get_json()['username']
        password = request.get_json()['password']
        firstname = request.get_json()['firstname']
        lastname = request.get_json()['lastname']
        cur.execute('SELECT EXISTS (SELECT * FROM users WHERE username=%s);', (username,))
        d = cur.fetchone()
        if d['exists']:
            return jsonify(d)
        else:
            cur.execute('SELECT createuser(%s, %s, %s, %s);', (username, password, firstname, lastname))
            conn.commit()
            return jsonify(d)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
