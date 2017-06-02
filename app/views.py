from flask import Flask, render_template, flash, request, redirect
from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField
from app import app



@app.route('/')
@app.route('/index')
def index():
	return render_template('form.html', title="Login Page")


logins = []
@app.route('/login', methods=['GET', 'POST'])
def login():
	user = request.form['u']
	mypass = request.form['p']
	logins.append(user + " " + mypass)
	print(logins)
	return redirect('/animation')

@app.route('/stored', methods=['GET', 'POST'])
def stored():
	return render_template('stored.html', logins=logins)

@app.route('/animation', methods=['GET', 'POST'])
def animation():
	return render_template('test.html', logins = logins)