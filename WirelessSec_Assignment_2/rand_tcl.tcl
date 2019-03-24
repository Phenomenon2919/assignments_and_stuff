set val(chan)			Channel/WirelessChannel
set val(prop)			Propagation/TwoRayGround
set val(netif)			Phy/WirelessPhy
set val(mac)			Mac/802_11
set val(ifq)			Queue/DropTail/PriQueue
set val(ifqlen)			65536
set val(ll)				LL
set val(ant)			Antenna/OmniAntenna
set val(rp)				DSDV
set val(maxx)			200
set val(maxy)			200
set val(nn)				[lindex $argv 0]
set val(mal)			[lindex $argv 1]
set val(ben)			[lindex $argv 2]
set ben_con				0
set val(time_malicious) 0.0 			

###################################################
# set val(def_pow)		[Phy/WirelessPhy set Pt_]
# set val(incr_pow)		[expr {$val(def_pow) * 10}]

# set w_channel [new Channel/WirelessChannel]
# w_channel set RXThresh_ 50
# set l [new Phy/WirelessPhy]
# netif set RXThresh_ 50

# Phy/WirelessPhy set CSThresh_ 10.00e-12
# Phy/WirelessPhy set RXThresh_ 10.00e-11
# Phy/WirelessPhy set CPThresh_

# puts "The CS Thresh is: [Phy/WirelessPhy set CSThresh_]"
# puts "The RX Thresh is: [Phy/WirelessPhy set RXThresh_]"
# puts "The CP Thresh is: [Phy/WirelessPhy set CPThresh_]"

# Phy/WirelessPhy set CSThresh_ 10.00e-12
# Phy/WirelessPhy set RXThresh_ 10.00e-11
# Phy/WirelessPhy set CPThresh_ 20.0

# puts "\nAfter changing the values..."
# puts "The CS Thresh is: [Phy/WirelessPhy set CSThresh_]"
# puts "The RX Thresh is: [Phy/WirelessPhy set RXThresh_]"
# puts "The CP Thresh is: [Phy/WirelessPhy set CPThresh_]"

#####################################################
set ns_ [new Simulator]
set topo [new Topography]
$topo load_flatgrid $val(maxx) $val(maxy)
create-god $val(nn)
set chan_1 [new $val(chan)]


# set namtrace_fh [open "$argv0.nam" w]
# $ns_ namtrace-all-wireless $namtrace_fh $val(maxx) $val(maxy)
set trace_fh [open "$argv0.tr" w]
$ns_ trace-all $trace_fh

set plot_file [open "plot_file" w]

#######################################
# For Debuging
set debug_file [open "debug_file" w]

#####################################################

#set f0 [open out0.tr w]

$ns_ node-config	-adhocRouting $val(rp) \
					-llType $val(ll) \
					-macType $val(mac) \
					-ifqType $val(ifq) \
					-ifqLen $val(ifqlen) \
					-antType $val(ant) \
					-propType $val(prop) \
					-phyType $val(netif) \
					-topoInstance $topo \
					-channel $chan_1 \
					-agentTrace ON \
					-routerTrace OFF\
					-macTrace OFF \
					-movementTrace OFF


# # Characteristics of Phy/WirelessPhy:

# # Characteristic (Unit)			| InstaVarName	| Default Val 	| Purpose						| Effect on range
# # ------------------------------+---------------+---------------+-------------------------------+-------------------------------------------
# # Transmission Power(W)			| Pt_			| 0.28183815	| Transmitted signal power 		| Directly proportional (tried with 10.0)
# # Frequency	(Hz)				| freq_			| 914e+6		| Signal frequency 				| No effect
# # System Loss Factor			| L_			| 1.0			| System loss factor 			| Indirectly proportional (tried with 0.4)
# # Receiving power threshold (W)	| RXThresh_		| 3.652e-10		| Receiving power threshold		| Indirectly proportional (tried with 3.652e-11)
# # Carrier Sense Threshold (W)	| CSThresh_		| 1.559e-11		| Carrier sense threshold 		| No effect
# # Capture threshold (W)			| CPThresh_		| 10.0			| Capture threshold 			| No effect


# # Altering the characteristics of certain instavars
# # Phy/WirelessPhy set Pt_ 10.0
# # Phy/WirelessPhy set freq_ 90.0
# # Phy/WirelessPhy set L_ 0.4
# # Phy/WirelessPhy set RXThresh_ 3.652e-11
# # Phy/WirelessPhy set CSThresh_ 1.559e+0
# # Phy/WirelessPhy set CPThresh_ 100.0

# Phy/WirelessPhy set Pt_ $val(def_pow)

#Defining the nodes

#

###################################################


#Node Defining & positioning


#
# $node_(0) set X_ 0.0
# $node_(0) set Y_ 100.0
# $node_(0) set Z_ 0.0

# $node_(1) set X_ 100.0
# $node_(1) set Y_ 150.0
# $node_(1) set Z_ 0.0  

# $node_(2) set X_ 200.0
# $node_(2) set Y_ 100.0
# $node_(2) set Z_ 0.0

for {set i 0} {$i < $val(nn)} {incr i} {
	set node_($i) [$ns_ node]
	$node_($i) set X_ [expr {int( rand() * $val(maxx) )}]
	$node_($i) set Y_ [expr {int( rand() * $val(maxy) )}]
	$node_($i) set Z_ 0.0
	$node_($i) random-motion 0
	$ns_ initial_node_pos $node_($i) 30

	if {$i >= $val(ben)} {

		$node_($i) color Blue
		$ns_ at 0.0 "$node_($i) color Blue"
	}
}

###########################################

# for {set i 0} {$i < $val(nn)} {incr i} {
# 	$ns_ initial_node_pos $node_($i) 30
# 	$node_($i) random-motion 0
# }


##############################################
## Creating Connectons between nodes

set node_count 0



### Creating benign connections
for {set i 0} {$i < $val(ben)} {incr i} {

	for {set j 0} {$j < $val(ben)} {incr j} {

		if {$i != $j} {

			set r_num [expr {int(rand()*2)}]

			if {$r_num == 1} {

				set udp_($node_count) [new Agent/UDP]
				$ns_ attach-agent $node_($i) $udp_($node_count)
				set cbr_($node_count) [new Application/Traffic/CBR]
				$cbr_($node_count) attach-agent $udp_($node_count)

				set lm_($node_count) [new Agent/LossMonitor]
				$ns_ attach-agent $node_($j) $lm_($node_count)	

				$ns_ connect $udp_($node_count) $lm_($node_count)

				incr node_count;
				
			}
		}

	}		
}

set ben_con [expr {$node_count+0}]

	# set tcp_($i) [new Agent/UDP]
	# $ns_ attach-agent $node_($i) $tcp_($i)
	# set cbr_($i) [new Application/Traffic/CBR]
	# $cbr_($i) attach-agent $tcp_($i)

### Creating malicious connections
for {set i $val(ben)} {$i < $val(nn)} {incr i} {

	for {set j 0} {$j < $val(ben)} {incr j} {

		set udp_($node_count) [new Agent/UDP]
		# $udp_($node_count) set rate_ 10E7
		# $udp_($node_count) set packetSize_ 65536
		$ns_ attach-agent $node_($i) $udp_($node_count)
		set cbr_($node_count) [new Application/Traffic/CBR]
		$cbr_($node_count) set rate_ 10E7
		$cbr_($node_count) set packetSize_ 65536
		$cbr_($node_count) attach-agent $udp_($node_count)

		set lm_($node_count) [new Agent/LossMonitor]
		$ns_ attach-agent $node_($j) $lm_($node_count)

		$ns_ connect $udp_($node_count) $lm_($node_count)

		incr node_count;

	}
}

# set tcp0 [new Agent/UDP]
# $ns_ attach-agent $node_(0) $tcp0
# set cbr0 [new Application/Traffic/CBR]
# $cbr0 attach-agent $tcp0



# set tcp1 [new Agent/UDP]
# $tcp1 set rate_ 10E7
# $tcp1 set packetSize_ 65536
# $ns_ attach-agent $node_(1) $tcp1
# set cbr1 [new Application/Traffic/CBR]
# $cbr1 attach-agent $tcp1


# set lm0 [new Agent/LossMonitor]
# $ns_ attach-agent $node_(2) $lm0

# # set sink0 [new Agent/TCPSink]
# # set sink1 [new Agent/TCPSink]
# # $ns_ attach-agent $node_(2) $sink0
# # $ns_ attach-agent $node_(2) $sink1

# set lm1 [new Agent/LossMonitor]
# $ns_ attach-agent $node_(2) $lm1


# # $ns_ connect $tcp0 $sink0
# # $ns_ connect $tcp1 $sink1
# $ns_ connect $tcp0 $lm0
# $ns_ connect $tcp1 $lm1
# $ns_ at 5.0 "$ftp0 start"
# $ns_ at 7.0 "$ftp1 start"
################################################


######################################
## Timing the start of packet transfer

### Timing the start of benign packet transfer
# $ns_ at 5.0 "$cbr0 start"
puts $ben_con
for {set i 0} {$i < $ben_con} {incr i} {
	$ns_ at 0.0 "$cbr_($i) start"
}

### Timing the start of malicious packet transfer
# $ns_ at 7.0 "$cbr1 start"

$ns_ at $val(time_malicious) "rand_mal"

# for {set i $ben_con} {$i < $node_count} {incr i} {
# 	$ns_ at 0.0 "$cbr_($i) start"
# }
###########################################


proc finish {} {
	global ns_ trace_fh argv0 ;#namtrace_fh ;#f0
	$ns_ flush-trace
	#close $namtrace_fh
	close $trace_fh
	#exec nam "$argv0.nam" &
	#close $f0
	#exec xgraph plot_file &
	exit 0
}

proc rand_mal {} {
	global ns_ ben_con node_count cbr_ val

	set cur_time [$ns_ now]

	for {set i $ben_con} {$i < $node_count} {incr i} {
		$ns_ at $val(time_malicious) "$cbr_($i) start"
	}

	set end_time [expr {$val(time_malicious) + 1 + rand()*3}]

	for {set i $ben_con} {$i < $node_count} {incr i} {
		$ns_ at $end_time "$cbr_($i) stop"
	}

	set val(time_malicious) [expr {$end_time + 1 + rand()*3}]

	if { $val(time_malicious) < 20.0 } {
		$ns_ at $val(time_malicious) "rand_mal"
	}

}



proc record {} {
        global lm_ ns_ val plot_file ben_con debug_file
        #Get an instance of the simulator
        #set ns [Simulator instance]
        #Set the time after which the procedure should be called again
        set cur_time [$ns_ now]
        set no_of_bytes 0

        for {set i 0} {$i < $ben_con} {incr i} {

        	set no_of_bytes [expr {$no_of_bytes + [$lm_($i) set bytes_]}]
        	$lm_($i) set bytes_ 0
        }

        puts $plot_file [expr {$no_of_bytes/20.0}]

        ###########################################
        # Debug code
        # puts $debug_file "$cur_time [expr {$no_of_bytes}]"

        # $ns_ at [expr {$cur_time + 1.0}] "record"


        #########################################


        # set time 0.5
        # #How many bytes have been received by the traffic sinks?
        # set bw0 [$lm0 set bytes_]
        # #Get the current time
        # set now [$ns now]
        # #Calculate the bandwidth (in MBit/s) and write it to the files
        # puts $f0 "$now [expr $bw0/$time*8]"
        # #Reset the bytes_ values on the traffic sinks
        # $lm0 set bytes_ 0
        # # $sink1 set bytes_ 0
        # # $sink2 set bytes_ 0
        # #Re-schedule the procedure
        # $ns at [expr $now+$time] "record"
}

$ns_ at 20.0 "record"
$ns_ at 20.1 "finish"
$ns_ run
