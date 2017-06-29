import os
import sass

directory = os.path.dirname(__file__)
filename = os.path.join(directory, 'static', 'animationstyle.css')


def main(spanNum):
	overall = ''
	for x in range(1,spanNum+1):
		overall += sass.compile(string = "#num" + str(x) + " { animation-delay: " + str(0.4 + 0.2*x) + "s; }")
		overall += "\n"
	with open(filename, 'a') as f:
		f.write(overall)
	return
