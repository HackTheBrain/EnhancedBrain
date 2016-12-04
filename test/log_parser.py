# parsing of our logs

import numpy, sys, re

def parse_it(log_file):
	correct = []
	time = []
	with open(log_file, 'r') as f:
		read_data = f.readlines()
	
	for row in read_data:
		row = row.split(';')
		
		t = int(re.sub("[^0-9]", "", row[-1]))
		time.append(t)
		
		a = int(re.sub("[^0-9]", "", row[0]))
		b = int(re.sub("[^0-9]", "", row[-2]))
		
		answ = 1 if a == b else 0
		correct.append(answ)
	
	f.close()
	print 'avg time: ' + str(numpy.mean(time)) 
	print 'std time: ' + str(numpy.std(time)) 
	print 'success: ' + str(100*sum(correct)/len(correct)) + '% of ' + str(len(correct)) + '('+str(sum(correct))+' correct)'


if len(sys.argv)==1:
	print "You should use it like \"log_parsr.py <path to the log file>\""
	quit()
	
log_file = sys.argv[1]
parse_it(log_file)