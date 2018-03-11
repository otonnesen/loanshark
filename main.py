import json
from flask import Flask, jsonify

filepath = "data.json"

app = Flask(__name__)

@app.route("/data")
def index():
    with open(filepath, "r") as f:
        d = json.load(f)
        return jsonify(d)


if __name__ == "__main__":
    app.run(debug=True)
