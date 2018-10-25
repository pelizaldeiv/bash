#!/bin/bash
if [ $# -lt 5 ]
  then
    echo 'Not enough arguments. Script should be ran as::
bash ip_checker.sh $1 $2 $3 $4 $5

where $1 is the first 2 octets:: 172.30

$2 is the comma separated list of the third octet :: 236,240,244

$3 and $4 is the beginning and ending range for final octet:: 1 255

$5 is the number of ips needed:: 5'


echo -e "\n\nEXAMPLE: bash ip_checker.sh 172.30 236,240,244 80 100 10
--------
This checks for the first 10 available IPS in the following ranges::

172.30.236
172.30.240
172.30.244

where the last octet is between 80 and 100 "
  exit
fi

for i in `echo $2 | sed 's/,/ /g'`
  do
    for j in $(seq $3 $4 )
      do
        ip=$1.$i.$j
        ping -c1 $1.$i.$j > /dev/null
        if [ $? -ne 0 ]
        then
          valid_ip+=($ip)
        else
          continue
        fi
        a=$(echo ${#valid_ip[@]})
        if [ $a -eq $5 ]
          then 
            echo "First ${5} available ips for ${1}.$i.x::"
            echo "=========="
            for x in "${valid_ip[@]}"
             do
             echo $x
             valid_ip=()
            done
            echo "=========="
            break
        else
          continue
        fi
    done
  done

