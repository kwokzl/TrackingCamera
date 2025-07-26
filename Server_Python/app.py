from flask import *
from det import main as detMain
from don import main as donMain
from user import main as userMain


app = Flask(__name__)

@app.route('/det')
def det():
    return detMain()

@app.route('/don')
def don():
    return donMain()

@app.route('/user')
def user():
    return userMain()

app.run('0.0.0.0',port=8080,debug=True)