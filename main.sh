#!/bin/bash

TARGET=$1
declare -a LOCATIONS 

# Must create an account with mapquest and create an API key
URL1="https://www.mapquestapi.com/staticmap/v5/map?key=KEY&shape=border:0000ff"
URL2="&size=800,800@2x"

echo "Starting, this may take a while..."

# Check if curl and traceroute are installed
command -v curl >/dev/null || { echo "curl command not found."; exit 1; }
command -v traceroute >/dev/null || { echo "traceroute command not found."; exit 1; }

# Create an array of IP addresses
DEVICES=($(traceroute -I $TARGET | cut -d " " -f 5 | sed 's/.//;s/.$//'))

# For each IP address, find it's geo coordinates from ipinfo.io
for i in ${!DEVICES[@]}; do
    LOCATIONS+=("$(curl -s https://ipinfo.io/${DEVICES[i]} | grep loc | cut -d\" -f 4 )")
    # echo ${DEVICES[i]}
done

# Add coordinates into long string for API request
for i in ${!LOCATIONS[@]}; do
    # echo ${LOCATIONS[i]}
    STRING+="|"
    STRING+=${LOCATIONS[i]}
done

# drop the first character
STRING=${STRING:1}

# concatenate all strings together for mapquest API
URL="$URL1$STRING$URL2"

# download result from mapquest
curl $URL -o route-$(echo $TARGET | cut -d '.' -f 1).png

