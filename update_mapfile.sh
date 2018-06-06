#!/bin/bash

MAPFILE=/var/www/html/map/htdocs/itasca.map
MAPHEADER=/var/www/html/map/htdocs/itasca.header
MAPFOOTER=/var/www/html/map/htdocs/itasca.footer
MAPMSGDIR=/var/www/html/map/htdocs/msg

SPOOLDIR=/var/spool/outgoing_messages
MAPDIR=/var/www/html/map/htdocs



while true; do

    FILENAME=$(inotifywait -e close_write -e moved_to ${SPOOLDIR} | cut -d " " -f 3)

    if echo ${FILENAME} | grep 'map'; then
      mv ${SPOOLDIR}/${FILENAME} ${MAPMSGDIR}/${FILENAME}
      echo "MOVED ${FILENAME}"

      cat ${MAPHEADER} > ${MAPFILE}
      for i in $(ls -1 ${MAPMSGDIR}); do
        cat ${MAPMSGDIR}/$i >> ${MAPFILE}
        echo "Adding to map ${i}"
      done
      cat ${MAPFOOTER} >> ${MAPFILE}
    fi

done;

