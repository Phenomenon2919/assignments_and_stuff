import os
import sys


const_tcl = "inc_tcl.tcl"
rand_tcl = "rand_tcl.tcl"
per_tcl = "per_tcl.tcl"

out_const = open("out_const","w")
out_per = open("out_per","w")
out_ran = open("out_ran","w")

cons_trace = "inc_tcl.tcl.tr"
const_delay = "const_delay"

ran_trace = "rand_tcl.tcl.tr"
ran_delay = "ran_delay"

per_trace = "per_tcl.tcl.tr"
per_delay = "per_delay"

# cbrgen_file = "cbrgen_out"
# results = "graph"

# num_of_nodes = 20



# os.system("ns cbrgen.tcl -type tcp -nn "+num_of_nodes+" -seed 1.0 -mc 10 -rate 5.0 > "+cbrgen_out)




num_of_nodes = int(sys.argv[1])

percent_mal = [0,10,20,30,40,50]

out_del = open(const_delay,"w")

#################################################################
## For Constant Jamming
for x in percent_mal:

	num_of_mal = x*num_of_nodes/100
	num_of_ben = num_of_nodes - num_of_mal

	os.system("ns "+const_tcl+" "+str(num_of_nodes)+" "+str(num_of_mal)+" "+str(num_of_ben))

	infile = open("plot_file","r")
	throughput = str(infile.readline())
	throughput = float(throughput[0:len(throughput)])
	infile.close()

	out_const.write(str(x)+" "+str(throughput)+"\n")


	##Calculating the delay
	time_sent = dict()

	inp_trace = open(cons_trace,"r")
	line = inp_trace.readline().split()

	# print line
	#['s', '0.000000000', '_0_', 'AGT', '---', '0', 'cbr', '210', '[0', '0', '0', '0]', '-------', '[0:0', '3:0', '32', '0]', '[0]', '0', '0']
	avg_delay = 0
	packet = 0
	# ctr = 0
	while line!=[]:
		# ctr += 1
		if line[3] == "AGT" and int(line[2][1:2])<num_of_ben:
			# print ctr," ",line[0]," ",line[5]
			if line[0] == 's':
				time_sent[line[5]] = float(line[1][:len(line[1])])
			elif line[0] == 'r':
				s_t = time_sent.pop(line[5],None)
				if s_t == None:
					line = inp_trace.readline().split()
					continue
				r_t = float(line[1][:len(line[1])])
				delay = r_t - s_t

				packet += 1
				avg_delay += delay
		line = inp_trace.readline().split()
	avg_delay /= packet

	out_del.write(str(x)+" "+str(avg_delay)+"\n")

out_del.close()
out_const.close()


##################################################################
## For Random Jamming
out_del = open(ran_delay,"w")
for x in percent_mal:

	num_of_mal = x*num_of_nodes/100
	num_of_ben = num_of_nodes - num_of_mal

	os.system("ns "+rand_tcl+" "+str(num_of_nodes)+" "+str(num_of_mal)+" "+str(num_of_ben))

	infile = open("plot_file","r")
	throughput = str(infile.readline())
	throughput = float(throughput[0:len(throughput)])
	infile.close()

	out_ran.write(str(x)+" "+str(throughput)+"\n")


	##Calculating the delay
	time_sent = dict()

	inp_trace = open(ran_trace,"r")
	line = inp_trace.readline().split()

	# print line
	#['s', '0.000000000', '_0_', 'AGT', '---', '0', 'cbr', '210', '[0', '0', '0', '0]', '-------', '[0:0', '3:0', '32', '0]', '[0]', '0', '0']
	avg_delay = 0
	packet = 0
	# ctr = 0
	while line!=[]:
		# ctr += 1
		if line[3] == "AGT" and int(line[2][1:2])<num_of_ben:
			# print ctr," ",line[0]," ",line[5]
			if line[0] == 's':
				time_sent[line[5]] = float(line[1][:len(line[1])])
			elif line[0] == 'r':
				s_t = time_sent.pop(line[5],None)
				if s_t == None:
					line = inp_trace.readline().split()
					continue
				r_t = float(line[1][:len(line[1])])
				delay = r_t - s_t

				packet += 1
				avg_delay += delay
		line = inp_trace.readline().split()
	avg_delay /= packet

	out_del.write(str(x)+" "+str(avg_delay)+"\n")

out_del.close()
out_ran.close()



#################################################################
## For Periodic JAmming
out_del = open(per_delay,"w")
for x in percent_mal:

	num_of_mal = x*num_of_nodes/100
	num_of_ben = num_of_nodes - num_of_mal

	os.system("ns "+per_tcl+" "+str(num_of_nodes)+" "+str(num_of_mal)+" "+str(num_of_ben))

	infile = open("plot_file","r")
	throughput = str(infile.readline())
	throughput = float(throughput[0:len(throughput)])
	infile.close()

	out_per.write(str(x)+" "+str(throughput)+"\n")


	##Calculating the delay
	time_sent = dict()

	inp_trace = open(per_trace,"r")
	line = inp_trace.readline().split()

	# print line
	#['s', '0.000000000', '_0_', 'AGT', '---', '0', 'cbr', '210', '[0', '0', '0', '0]', '-------', '[0:0', '3:0', '32', '0]', '[0]', '0', '0']
	avg_delay = 0
	packet = 0
	# ctr = 0
	while line!=[]:
		# ctr += 1
		if line[3] == "AGT" and int(line[2][1:2])<num_of_ben:
			# print ctr," ",line[0]," ",line[5]
			if line[0] == 's':
				time_sent[line[5]] = float(line[1][:len(line[1])])
			elif line[0] == 'r':
				s_t = time_sent.pop(line[5],None)
				if s_t == None:
					line = inp_trace.readline().split()
					continue
				r_t = float(line[1][:len(line[1])])
				delay = r_t - s_t

				packet += 1
				avg_delay += delay
		line = inp_trace.readline().split()
	avg_delay /= packet

	out_del.write(str(x)+" "+str(avg_delay)+"\n")

out_del.close()
out_per.close()







