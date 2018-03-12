import os
import json
from flask import Flask, jsonify

filepath = "data.json"

app = Flask(__name__)

@app.route("/data")
def index():
    with open(filepath, "r") as f:
        d = json.load(f)
        return jsonify(d)

@app.route("/")
def main():
    return "Large business"


if __name__ == "__main__":
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
