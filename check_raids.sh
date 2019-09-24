#!/bin/bash

usage() { echo "Usage: $0 [-o <threshold value for OK>] [-w <threshold value for WARNING>] [-u <DB user>] [-p <DB password>] [-d <Database>]" 1>&2; exit 1; }

while getopts o:w:u:p:d: option
do
	case "${option}"
		in
		o) OK=${OPTARG};;
		w) WARN=${OPTARG};;
		u) USER=${OPTARG};;
		p) PASS=$OPTARG;;
		d) DB=${OPTARG};;
		*) usage;;
	esac
done

#query local DB
raids=$(export MYSQL_PWD=${PASS};  mysql -u ${USER} -D ${DB} -N -B -e "SELECT COUNT(*) total, SUM(CASE WHEN level=1 THEN 1 ELSE 0 END) level1, SUM(CASE WHEN level=2 THEN 1 ELSE 0 END) level2, SUM(CASE WHEN level=3 THEN 1 ELSE 0 END) level3, SUM(CASE WHEN level=4 THEN 1 ELSE 0 END) level4, SUM(CASE WHEN level=5 THEN 1 ELSE 0 END) level5 FROM raid WHERE end > UTC_TIMESTAMP()")
array=($(for i in $raids; do echo $i; done))
output="Current raids: ${array[0]} | current_raids=${array[0]}, current_raids_1=${array[1]}, current_raids_2=${array[2]}, current_raids_3=${array[3]}, current_raids_4=${array[4]}, current_raids_5=${array[5]}"

if [ "${array[0]}" -gt "${OK}" ]
then
    echo "OK - $output"
    exit 0
elif [ "${array[0]}" -gt "${WARN}" ]
then
    echo "WARNING - $output"
    exit 1
elif [ "${array[0]}" -le "${WARN}" ]
then
    echo "CRITICAL - $output"
    exit 2
else
    echo "UNKNOWN - $output"
    exit 3
fi
