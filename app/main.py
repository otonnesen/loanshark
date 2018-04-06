import os
import psycopg2
from psycopg2.extras import RealDictCursor
import json
# Replaces flask.jsonify to work with Decimal type
import simplejson
from flask import Flask, jsonify, render_template, request, redirect, make_response, session, flash
from flask_login import LoginManager

try:
    DATABASE_URL = os.environ['DATABASE_URL']
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
except LookupError:
    # Local env
    conn = psycopg2.connect(host='localhost', dbname='loanshark', user='oliver', password=os.environ['pw'])


app = Flask(__name__)
app.secret_key = os.environ['secretkey']

@app.route('/', methods=['GET'])
def main():
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
    if not session['username'] == 'admin':
        return 'Access Denied' #TODO
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM get_all_transactions() ORDER BY transactionid;')
        d = cur.fetchall()
        return jsonify(d)

@app.route('/data/users', methods=['GET'])
def getUserData():
    if not session['username'] == 'admin':
        return 'Access Denied'
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM users;')
        d = cur.fetchall()
        return jsonify(d) 

@app.route('/settings', methods=['GET'])
def settings():
    # Change password, name, etc
    return render_template('settings.html')

@app.route('/transactions', methods=['GET'])
def transactions():
    if 'username' not in session:
        return render_template('transaction_list.html')
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        id = session['username']
        cur.execute('SELECT * FROM get_credit_data(%s)', (id,))
        credit = cur.fetchall()
        cur.execute('SELECT * FROM get_debt_data(%s)', (id,))
        debt = cur.fetchall()
        return render_template('transaction_list.html', credList=credit, debtList=debt)

@app.route('/data/<string:id>')
def getIdData(id):
    if not session['username'] == 'admin':
        return 'Access Denied' #TODO
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute('SELECT * FROM get_credit_data(%s) UNION SELECT * FROM get_debt_data(%s)', (id, id))
        d = cur.fetchall()
        return jsonify(d)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.get_json()['username']
        password = request.get_json()['password']
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute('SELECT validate(%s, %s);', (username, password))
            d = cur.fetchone()
            if(d['validate']==True):
                session['username'] = username
                flash('Login successful!')
            return jsonify(d)
    with conn.cursor() as cur:
        return render_template('login.html')

@app.route('/logout', methods=['GET'])
def logout():
    session.pop('username', None)
    flash('Logged out')
    return redirect('/')

@app.route('/create')
def create():
    with conn.cursor() as cur:
        return render_template('create.html')

# @app.route('/checkCred', methods=['POST'])
# def checkCred():
#     username = request.get_json()['username']
#     password = request.get_json()['password']
#     with conn.cursor(cursor_factory=RealDictCursor) as cur:
#         cur.execute('SELECT validate(%s, %s);', (username, password))
#         d = cur.fetchone()
#         if(d['validate']==True):
#             session['username'] = username
#         return jsonify(d)

@app.route('/createUser', methods=['POST'])
def createUser():
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        username = request.get_json()['username']
        password = request.get_json()['password']
        firstname = request.get_json()['firstname']
        lastname = request.get_json()['lastname']
        cur.execute('SELECT EXISTS (SELECT * FROM users WHERE username=%s);', (username,))
        d = cur.fetchone()
        if not d['exists']: # Username available
            print('test')
            flash('Success! You may now login.')
            cur.execute('SELECT createuser(%s, %s, %s, %s);', (username, password, firstname, lastname))
            conn.commit()
        return jsonify(d)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
