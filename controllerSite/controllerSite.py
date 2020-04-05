import os
from flask import Flask, flash, request, jsonify, redirect, url_for, render_template
from flask_socketio import SocketIO
from flask_bootstrap import Bootstrap
from werkzeug.utils import secure_filename

app = Flask(__name__)
socketio = SocketIO(app)
clients = {}

queue = []

app.secret_key = 'super secret key'
app.config['UPLOAD_FOLDER'] = 'upload'
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}
Bootstrap(app)

def remove_id(id):
    queue.remove(id)

@app.route('/')
def index():
    return render_template('index.html')

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/multicast/<string:code>', methods=['GET', 'POST'])
def multicast(code):
    if request.method == 'POST':
        content = request.json
        print(code,content['id'])
        socketio.emit('multicast', jsonify(content), callback=confirmReception,namespace='/'+code)
        return jsonify({"code":code,"id":content['id']})
    return '''
    <!doctype html>
    <title>Use a HTTP POST Request</title>
    '''
def confirmReception():
    print('Message Received.')

@socketio.on('code')
def handle_code(json, methods=['GET', 'POST']):
    print('code received: ' + str(json))
    socketio.emit('message', json, callback=confirmReception,namespace='/a1b2c3')

if __name__ == '__main__':
    socketio.run(app,debug = True,host = "0.0.0.0",port = 80)


    
