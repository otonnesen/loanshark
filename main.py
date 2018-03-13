import os
import psycopg2
import json
from flask import Flask, jsonify, render_template

filepath = 'static/data.json'
DATABASE_URL = os.environ['DATABASE_URL']

conn = psycopg2.connect(DATABASE_URL, sslmode='require')

app = Flask(__name__)

@app.route('/data')
def index():
    with open(filepath, 'r') as f:
        d = json.load(f)
        return jsonify(d)

@app.route('/')
def main():
    return 'test'

@app.route('/test')
def test():
    return render_template('main.html')


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
