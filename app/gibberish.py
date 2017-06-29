import os

directory = os.path.dirname(__file__)
filename = os.path.join(directory, 'static', 'test.css')

with open(filename, 'r') as f:
	read_data = f.read()

print("hello world")