from flask import Flask, render_template, flash, request, redirect
from app import app
from . import allitdetect

@app.route('/')
@app.route('/index')
def index():
	return render_template('form.html', title="Login Page")

@app.route('/login', methods=['POST', 'GET'])
def login():
	inputs = request.form
	inputString = inputs.get('inputstring')
	allitDict = allitdetect.main(inputString)
	print(type(allitDict))
	return render_template("stored.html", title="Success", allitDict = allitDict, inputString = inputString)

