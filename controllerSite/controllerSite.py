# ControllerApp Site running on https://www.controllerapp.ml
# Written by Faruk Hammoud, 2020
# sudo pm2 start controllerSite.py --name flask-app --interpreter=python3

from flask import Flask, request, jsonify, render_template
from flask_bootstrap import Bootstrap
from flask_socketio import SocketIO, emit
import eventlet

app = Flask(__name__)
app.secret_key = 'super secret key'
socketio = SocketIO(app)
Bootstrap(app)

@app.route('/')
def index():
    return render_template('index.html')
 
if __name__ == '__main__':
    eventlet.wsgi.server(eventlet.wrap_ssl(eventlet.listen(("0.0.0.0", 443)),
        certfile='/etc/letsencrypt/live/www.controllerapp.ml/fullchain.pem',
        keyfile='/etc/letsencrypt/live/www.controllerapp.ml/privkey.pem',
        server_side=True), app) 
    #app.run(host='0.0.0.0',port=80,debug=True)




    
