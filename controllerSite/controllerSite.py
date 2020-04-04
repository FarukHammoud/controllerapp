import os
from flask import Flask, flash, request, jsonify, redirect, url_for, render_template
from flask_bootstrap import Bootstrap
from werkzeug.utils import secure_filename

app = Flask(__name__)

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

@app.route('/multicast/<string:id>', methods=['GET', 'POST'])
def upload_file(id):
    if request.method == 'POST':
        content = request.json
        print(content)
        return jsonify({"id":id})
    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload new File</h1>
    <form method=post enctype=multipart/form-data>
      <input type=file name=file>
      <input type=submit value=Upload>
    </form>
    '''

@app.route('/verify/<string:id>/')
def items(id):

    if id in queue:
        return 'False'
    else:
        return 'True'

if __name__ == '__main__':
    app.run(debug = True,host = "0.0.0.0",port = 80)


    
