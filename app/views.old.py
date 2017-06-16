from flask import Flask, render_template, flash, request, redirect
from app import app
from . import allitdetect
from .forms import InputForm

@app.route('/')
@app.route('/index')
def index():
	return render_template('form.html', title="Login Page")


logins = []
@app.route('/login', methods=['GET', 'POST'])
def login():
	form = InputForm()
	# user = request.form['u']
	# logins.append(user)
	# print(logins)
	# return redirect('/animation')
	if form.validate_on_submit():
		print(form.inputString.data)

@app.route('/stored', methods=['GET', 'POST'])
def stored():
	return render_template('stored.html', logins=logins)

@app.route('/animation', methods=['GET', 'POST'])
def animation():
	#inputString = request.form['inputstring']
	# print(allitdetect.main(inputString))
	# logins.append(inputString)
	#return render_template('stored.html', logins=logins)
	return render_template('stored.html', logins=logins)