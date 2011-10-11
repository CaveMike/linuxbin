#!/bin/bash
PORT="ttyUSB0"
DEVICE="/dev/${PORT}"
DIR="/tmp/${PORT}/"
LOGFILE="${DIR}${PORT}.log"
TMPFILE="${DIR}_${PORT}_${RANDOM}.log"

trap ctrl_c INT
function ctrl_c() {
   echo "CTRL-C trapped."
   ps ax  | egrep "cat ${DEVICE}" | awk '{print $1}' | xargs -i kill {} 2&>/dev/null
}

mkdir $DIR 1> /dev/null 2> /dev/null
mv ${LOGFILE} ${TMPFILE} 1> /dev/null 2> /dev/null

stty -F ${DEVICE} raw ispeed 115200 ospeed 115200 cs8 -ignpar -cstopb 
cat ${DEVICE} > ${LOGFILE} &

tail -f ${LOGFILE}

