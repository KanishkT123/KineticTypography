#app/__init__.py


from flask import Flask

#App and config initialization
app = Flask(__name__)
app.config.from_object('config')

#importing views.py from app module
from app import views
#from . import *