#!/bin/sh

usage() { echo "Usage: $0 [-o <threshold value for OK>] [-w <threshold value for WARNING>] [-u <DB user>] [-p <DB password>] [-d <Database>]" 1>&2; exit 1; }

while getopts ":o:w:u:p:d:" a; do
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
        *)
           usage
           ;;
    esac
done
shift $((OPTIND-1))

spawns=$(mysql -u ${u} -p${p} -D ${d} -N -B -e "SELECT COUNT(*) FROM trs_spawn WHERE calc_endminsec IS NULL")
output="Unknown Spawnpoints: $spawns | unkown_spawnpoints=$spawns"

if [ "$spawns" -lt "${o}" ]
then
    echo "OK - $output"
    exit 0
elif [ "$spawns" -lt "${w}" ]
then
    echo "WARNING - $output"
    exit 1
elif [ "$spawns" -ge "${w}" ]
then
    echo "CRITICAL - $output"
    exit 2
else
    echo "UNKNOWN - $output"
    exit 3
fi
