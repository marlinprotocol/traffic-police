#!/bin/bash
#
#  Usage
#  -----
#  tc-script.sh start - starts the shaper
#  tc-script.sh stop - stops the shaper
#  tc-script.sh restart - restarts the shaper
#  tc-script.sh - shows the rules currently being shaped
#
#  tc uses the following units when passed as a parameter.
#    kbps: Kilobytes per second
#    mbps: Megabytes per second
#    kbit: Kilobits per second
#    mbit: Megabits per second
#    bps: Bytes per second
#  Amounts of data can be specified in:
#    kb or k: Kilobytes
#    mb or m: Megabytes
#    mbit: Megabits
#    kbit: Kilobits
#
##

# Name of the traffic control command.
TC=/sbin/tc
# Rate to throttle to
RATE=1mbit
# Interface to shape
IF=eth0
# Average to delay packets by
LATENCY=10ms
# Jitter value for packet delay
# Packets will be delayed by $LATENCY +/- $JITTER
JITTER=10ms
# corrupt x% of the packets by introducing single bit error at a random offset in the packet
CORRUPT=0.1%
# paclet loss percent
LOSS=0.1%

start() {
    sudo $TC qdisc add dev $IF root netem \
    rate $RATE \
    delay $LATENCY $JITTER \
    loss $LOSS \
    corrupt $CORRUPT
}

stop() {
    sudo $TC qdisc del dev $IF root
}

restart() {
    stop
    sleep 1
    start
}

show() {
    $TC -s qdisc ls dev $IF
}

case "$1" in

start)

echo -n "Starting bandwidth shaping: "
start
echo "done"
;;

stop)

echo -n "Stopping bandwidth shaping: "
stop
echo "done"
;;

restart)

echo -n "Restarting bandwidth shaping: "
restart
echo "done"
;;

show)

echo "Bandwidth shaping status for $IF:"
show
echo ""
;;

*)

pwd=$(pwd)
echo "Usage: shaper.sh {start|stop|restart|show}"
;;

esac
exit 0

#!/bin/bash

# helpFunction()
# {
#    echo ""
#    echo "Usage: $0 -l latency(ms) -r rate(kbit) -c corruptPercent(%) -loss lossPercent(%)"
#    echo -e "\t-l introduces the latency in ms"
#    echo -e "\t-r limits the rate kbit per sec"
#    echo -e "\t-c percentage of packets to corrupt with 1 bit error"
#    echo -e "\t-c Description of what is parameterC"
#    exit 1 # Exit script after printing help
# }

# while getopts "a:b:c:" opt
# do
#    case "$opt" in
#       a ) parameterA="$OPTARG" ;;
#       b ) parameterB="$OPTARG" ;;
#       c ) parameterC="$OPTARG" ;;
#       ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
#    esac
# done

# # Print helpFunction in case parameters are empty
# if [ -z "$parameterA" ] || [ -z "$parameterB" ] || [ -z "$parameterC" ]
# then
#    echo "Some or all of the parameters are empty";
#    helpFunction
# fi

# Begin script in case all parameters are correct
