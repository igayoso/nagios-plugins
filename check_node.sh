#!/bin/bash
# 
# Nagios plugin to check if node is running
# 
# by Israel Gayoso Pérez (igayoso@gmail.com)
# 
# Command-line use example for service
# check_node!worker!1!9
#
#############################################################################

case $1 in
	--help | -h )
		echo "Usage: check_node [node_name] [min] [max]"
		echo " [min] and [max] as int"
		echo " Example: check_node worker 1 9"
		exit 3
		;;
	* )
		;;
esac

if [ ! "$1" -o ! "$2" -o ! "$3" ]
then
	echo "Usage: check_proc [node_name] [min] [max]"
	echo " [min] and [max] as int"
	echo " Example: check_node worker 1 9"
	echo "Unknown: Options missing"
	exit 3
fi

if [ "$2" -gt "$3" ]
then
	echo "Unknown: [max] must be larger than [min]"
	exit 3
fi

node_name=$1
min=$2
max=$3
nodes=`ps aux | grep node | grep $node_name | egrep -v "sudo|NODE|grep|check_node" | wc -l`

if [ "$nodes" -eq "$min" -o "$nodes" -gt "$min" ]
then
	if [ "$nodes" -lt "$max" -o "$nodes" -eq "$max" ]
	then
		echo "OK: $nodes node(s) running (min=$min, max=$max)"
		exit 0
	else
		echo "Warning: Too much nodes ($nodes/$max)"
		exit 1
	fi
elif [ "$nodes" -lt "$min" ]
then
	echo "Critical: Not enough nodes ($nodes/$min)"
	exit 2
else
	echo "Unknown error"
	exit 3
fi
