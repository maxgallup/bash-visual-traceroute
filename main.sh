#!/bin/bash

TARGET="www.washington.edu"
declare -a LOCATIONS 

# Must create an account with mapquest and create an API key
URL1="https://www.mapquestapi.com/staticmap/v5/map?key=KEY&shape=border:0000ff"
URL2="&size=800,800@2x"


# Check if curl and traceroute are installed
command -v curl >/dev/null || { echo "curl command not found."; exit 1; }
command -v traceroute >/dev/null || { echo "traceroute command not found."; exit 1; }


DEVICES=($(traceroute -I $TARGET | cut -d " " -f 5 | sed 's/.//;s/.$//'))

for i in ${!DEVICES[@]}; do
    LOCATIONS+=("$(curl -s https://ipinfo.io/${DEVICES[i]} | grep loc | cut -d\" -f 4 )")
    # echo ${DEVICES[i]}
done


for i in ${!LOCATIONS[@]}; do
    echo ${LOCATIONS[i]}
    STRING+="|"
    STRING+=${LOCATIONS[i]}
done

STRING=${STRING:1}

URL="$URL1$STRING$URL2"

echo $URL
curl $URL -o route-$TARGET.png

