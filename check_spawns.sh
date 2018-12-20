#!/bin/bash

usage() { echo "Usage: $0 [-o <threshold value for OK>] [-w <threshold value for WARNING>] [-u <DB user>] [-p <DB password>] [-d <Database>] [-t <Database-type. Monocle or RM>" 1>&2; exit 1; }

while getopts ":o:w:u:p:d:dt:" a; do
    case "${a}" in
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
        t)
            t=${OPTARG}
            ;;
        *)
           usage
           ;;
    esac
done
shift $((OPTIND-1))

#query local DB
if [ "$t" == "Monocle" ]
then
    pokemon=$(mysql -u ${u} -p${p} -D ${d} -N -B -e "select count(*) from sightings where expire_timestamp > unix_timestamp()")
elif [ "$t" == "RM" ]
then
    pokemon=$(mysql -u ${u} -p${p} -D ${d} -N -B -e "select count(*) from pokemon where disappear_time > utc_timestamp()")
else
    echo "Wrong Database-type, please use \"Monocle\" or \"RM\"!"
    exit 3
fi
output="Spawned pokemon: $pokemon | spawned_pokemon=$pokemon"

if [ "$pokemon" -gt "${o}" ]
then
    echo "OK - $output"
    exit 0
elif [ "$pokemon" -gt "${w}" ]
then
    echo "WARNING - $output"
    exit 1
elif [ "$pokemon" -le "${w}" ]
then
    echo "CRITICAL - $output"
    exit 2
else
    echo "UNKNOWN - $output"
    exit 3
fi
