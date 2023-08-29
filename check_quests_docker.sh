#!/bin/bash

usage() { echo "Usage: $0 [-c <container name>] [-o <threshold value for OK>] [-w <threshold value for WARNING>] [-u <DB user>] [-p <DB password>] [-d <Database>]" 1>&2; exit 1; }

while getopts ":c:o:w:u:p:d:" a; do
    case "${a}" in
        c)
            c=${OPTARG}
            ;;
        o)
            o=${OPTARG}
            ;;
        w)
            w=${OPTARG}
            ;;
        u)
            u=${OPTARG}
            ;;
        p)
            p=${OPTARG}
            ;;
        d)
            d=${OPTARG}
            ;;
        *)
           usage
           ;;
    esac
done
shift $((OPTIND-1))

quests=$(docker exec -t ${c} mysql -u ${u} -p${p} -D ${d} -N -B -e "SELECT COUNT(*) FROM trs_quest WHERE FROM_UNIXTIME(quest_timestamp) > CURDATE()" | tr -d '\r')
output="Current quests: $quests | qurrent_quests=$quests"

if [ "$quests" -gt "${o}" ]
then
    echo "OK - $output"
    exit 0
elif [ "$quests" -gt "${w}" ]
then
    echo "WARNING - $output"
    exit 1
elif [ "$quests" -le "${w}" ]
then
    echo "CRITICAL - $output"
    exit 2
else
    echo "UNKNOWN - $output"
    exit 3
fi