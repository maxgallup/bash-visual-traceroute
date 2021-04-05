#!/bin/bash

TARGET="google.com"
declare -a LOCATIONS 


# Check if curl and traceroute are installed
command -v curl >/dev/null || { echo "curl command not found."; exit 1; }


command -v traceroute >/dev/null || { echo "traceroute command not found."; exit 1; }




DEVICES=($(traceroute -I $TARGET | cut -d " " -f 5 | sed 's/.//;s/.$//'))

for i in ${!DEVICES[@]}; do
    LOCATIONS+=("$(curl -s https://ipinfo.io/${DEVICES[i]} | grep loc | cut -d\" -f 4 | sed 's/,/ /')")
    # echo ${DEVICES[i]}
done

for i in ${!LOCATIONS[@]}; do
    echo ${LOCATIONS[i]}
done



