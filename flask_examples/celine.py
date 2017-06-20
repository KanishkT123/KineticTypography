from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return "Welcome to the KiT page!"

@app.route('/animation/<word>')
def animation(word):
    return render_template("anim.html", word=word)