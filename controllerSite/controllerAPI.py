# ControllerApp API running on http://www.controllerapp.ml
# Written by Faruk Hammoud, 2020

# sudo pm2 start controllerSite.py --name flask-app --interpreter=python3

from flask import Flask, request, jsonify, render_template
from flask_socketio import SocketIO, emit
from flask_bootstrap import Bootstrap
from flask import Flask, redirect
import json as js

app = Flask(__name__)
app.secret_key = 'super secret key'
socketio = SocketIO(app)
Bootstrap(app)

@app.route('/')
def index():
    return redirect("https://www.controllerapp.ml", code=302)

@socketio.on('cast')
def handle_cast(json,methods=['GET','POST']):
    json = js.loads(json)
    code = json["code"]
    socketio.emit('multicast',json,broadcast=True,namespace='/'+code)

@socketio.on('code')
def handle_code(json, methods=['GET', 'POST']):
    print('code received!')
    socketio.emit('message', json,namespace='/a1b2c3')

if __name__ == '__main__':
    socketio.run(app,debug = False,host = "0.0.0.0",port = 80)  
