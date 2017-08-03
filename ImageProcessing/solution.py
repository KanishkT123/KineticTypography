x = 1
while True:
	tenx = 7*x
	flag = False
	for i in range(1,x+1):
		if tenx%i != 0:
			flag = True
			break
	if not flag:
		print(tenx)
	x += 1