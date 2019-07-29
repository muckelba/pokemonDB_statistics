#!/bin/bash

usage() { echo "Usage: $0 [-o <threshold value for OK>] [-w <threshold value for WARNING>] [-u <DB user>] [-p <DB password>] [-d <Database>] [-t <Database-type. Monocle or RM>]" 1>&2; exit 1; }

while getopts o:w:u:p:d:t: option
do
	case "${option}"
		in
		o) OK=${OPTARG};;
		w) WARN=${OPTARG};;
		u) USER=${OPTARG};;
		p) PASS=$OPTARG;;
		d) DB=${OPTARG};;
	        t) TYPE=${OPTARG};;
		*) usage;;
	esac
done

#query local DB
if [ "$TYPE" == "Monocle" ]
then
	raid=$(mysql -u ${USER} -p${PASS} -D ${DB} -N -B -e "select count(*) from raids where level=5 and time_end > unix_timestamp();")
elif [ "$TYPE" == "RM" ]
then
	raid=$(mysql -u ${USER} -p${PASS} -D ${DB} -N -B -e "SELECT COUNT(*) FROM raid WHERE level=5 AND end > UTC_TIMESTAMP()")
else
    echo "Wrong Database-type, please use \"Monocle\" or \"RM\"!"
    exit 3
fi

output="Current LVL 5 raids: $raid | current_raids=$raid"

if [ "$raid" -gt "${OK}" ]
then
    echo "OK - $output"
    exit 0
elif [ "$raid" -gt "${WARN}" ]
then
    echo "WARNING - $output"
    exit 1
elif [ "$raid" -le "${WARN}" ]
then
    echo "CRITICAL - $output"
    exit 2
else
    echo "UNKNOWN - $output"
    exit 3
fi
