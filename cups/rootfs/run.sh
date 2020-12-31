#!/usr/bin/with-contenv bashio

tempio \
    -conf /data/options.json \
    -template /usr/share/cupsd.conf.tempio \
    -out /etc/cups/cupsd.conf

tempio \
    -conf /data/options.json \
    -template /usr/share/cups-files.conf.tempio \
    -out /etc/cups/cups-files.conf

/usr/sbin/cupsd -f