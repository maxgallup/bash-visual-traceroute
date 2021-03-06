# bash-visual-traceroute
Visualize the `traceroute` command on UNIX based operating systems like Linux, BSD and Mac. Visualize individual hops that your traffic takes around the globe on a map. This can be advantageous to see how traffic is routed when using a VPN. Only for Linux/BSD/Mac.

### Usage
```
./main.sh google.com
```
This bash script only takes one argument, namely the destination target domain.

### Examples
This is the route when connecting to namecheap.com from amsterdam
![namecheap.com](route-namecheap.png)

# OLD BLOG post
# Visualize Traceroute with Simple Shell Scripting

[This simple shell script](https://github.com/maxgallup/bash-visual-traceroute) utilizes thrid-party services to create a geographical map that shows the route your traffic takes when accessing a public server. It uses `traceroute` to find the IP addresses of the intermediate and final devices. Then it looks up the geographical coordinates of these IP address using [ipinfo](https://ipinfo.io/1.1.1.1). Finally it makes a request to the [MapQuest API](https://developer.mapquest.com/) with the coordinates to draw a path between the origin and destination. 

  

## traceroute
Here we create an array that holds all the IP address returned by traceroute. The `-I` option is set to use ICMP echo instead of UDP, which seems to work better at times. after that the output is piped into `cut` and `sed` to filter out the IP address and get rid of surrounding parentheses. 
```sh
# Create an array of IP addresses
DEVICES=($(traceroute -I $TARGET | cut -d " " -f 5 | sed 's/.//;s/.$//'))
```

  

## ipinfo
We create another array that holds the geographical coordinates of each IP address. Again the output is filtered to get just the information needed with `grep` and `cut`.
```sh
for i in ${!DEVICES[@]}; do
    LOCATIONS+=("$(curl -s https://ipinfo.io/${DEVICES[i]} | grep loc | cut -d<br>" -f 4 )")
done
```

  

## MapQuest
The following API request returns a map using poly lines to connect the individual coordinates (LONGITUDE,LATITUDE) and finally outputs a png image of 800 by 800 pixels.
```sh
# Requires MapQuest API KEY
https://www.mapquestapi.com/staticmap/v5/map?key=KEY&shape=border:0000ff|LONGITUDE,LATITUDE|LONGITUDE2,LATITUDE2|LONGITUDE3,LATITUDE3&size=800,800@2x"
```

