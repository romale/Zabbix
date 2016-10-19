#!/bin/sh

HOST=$1
SNMP_COMMUNITY=$2
SNMP_INDEX=$3
SNMPGET_BIN="/usr/bin/snmpget"

test -x $SNMPGET_BIN || exit 5

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi

# IF-MIB::ifSpeed
ifspeed=`$SNMPGET_BIN -Otvq -c $SNMP_COMMUNITY -v 2c $HOST .1.3.6.1.2.1.2.2.1.5.$SNMP_INDEX`
# IF-MIB::ifHighSpeed
ifhspeed=`$SNMPGET_BIN -Otvq -c $SNMP_COMMUNITY -v 2c $HOST .1.3.6.1.2.1.31.1.1.1.15.$SNMP_INDEX`

if [[ -z $ifspeed || -z $ifhspeed ]]; then
    echo "Response of IF-MIB::ifSpeed or IF-MIB::ifHighSpeed is empty"
    exit 1
fi

if [[ $ifspeed < 4294967295 ]];then
    result=$ifspeed
    echo "$result"
    exit 0
else
    let tobits="$ifhspeed * 1000000"
    result=$tobits
    echo "$result"
    exit 0
fi
