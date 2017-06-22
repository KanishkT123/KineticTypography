from flask import Flask, render_template, flash, request, redirect
from app import app
from . import allitdetect
from string import punctuation

def strip_punctuation(inputString):
	x = ""
	for character in inputString:
		if character in punctuation:
			break
		else:
			x += character
	print(x)
	return x

@app.route('/')
@app.route('/index')
def index():
	return render_template('form.html', title="Input Page")

@app.route('/login', methods=['POST', 'GET'])
def login():
	inputs = request.form
	inputString = inputs.get('inputstring')
	allitDict = allitdetect.main(inputString)
	alliteratedWords = [item for sublist in allitDict.values() for item in sublist]
	print(alliteratedWords)
	return render_template("animation.html", title="Success", alliteratedWords = alliteratedWords, inputString = inputString, strip_punctuation=strip_punctuation)
