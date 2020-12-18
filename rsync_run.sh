#!/bin/bash

PASSWORD='OrmyigsoidVigIa'
COMPRESS='YES'
DRUN='NO'


LOCALDIR='/mnt/tmp'
RHOST='192.168.0.238 192.168.0.239'
RDIR='/mnt/tmp'
PORT='22'
USER='root'

RUNCMD="/usr/bin/sshpass -p $PASSWORD rsync -a"

for i in $RHOST; do


if [ "$COMPRESS" = "YES" ]; then
   if [ "$DRUN" = "YES" ]; then
#       echo "Doing for host $i"
        echo $RUNCMD -z -n -e \"ssh -p ${PORT} -C -o BatchMode=no\" ${LOCALDIR} ${USER}@${i}:${RDIR} >> /tmp/runrsync
   else
#       echo "1 Doing for host $i"
        echo $RUNCMD -z -e \"ssh -p ${PORT} -C -o BatchMode=no\" ${LOCALDIR} ${USER}@${i}:${RDIR} >> /tmp/runrsync

   fi
else
   if [ "$DRUN" = "YES" ]; then
#       echo "Doing for host $i"
        echo $RUNCMD -n -e \"ssh -p ${PORT} -C -o BatchMode=no\" ${LOCALDIR} ${USER}@${i}:${RDIR} >> /tmp/runrsync

   else
#       echo "Doing for host $i"
        echo $RUNCMD -e \"ssh -p ${PORT} -C -o BatchMode=no\" ${LOCALDIR} ${USER}@${i}:${RDIR} >> /tmp/runrsync

   fi
fi

done

FROM=`cat /tmp/runrsync | head -1 | awk -F '"' '{print $3}' | awk '{print $1}'`
TO=`cat /tmp/runrsync | head -1 | awk -F '"' '{print $3}' | awk -F ':' '{print $2}'`
HOSTS=`cat /tmp/runrsync | awk -F '"' '{print $3}' | awk -F '@' '{print $2}' | awk -F ':' '{print $1}'`


for h in $HOSTS; do
        echo "Now we copy files from $FROM to $TO on hosts $h"
done

echo "Сontinue? (y/N)"

read a

if [ "$a" = "y" ]; then
        echo "Copy running..."
        sh /tmp/runrsync
        rm /tmp/runrsync
        exit 0;
else
        echo "Exiting"
        rm /tmp/runrsync
        exit 0;
fi
