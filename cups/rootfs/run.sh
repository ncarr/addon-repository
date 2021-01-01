#!/usr/bin/with-contenv bashio

result=$(bashio::api.supervisor GET /core/api/config true || true)
internal=$(bashio::jq "${result}" '.internal_url' | cut -d'/' -f3 | cut -d':' -f1)
external=$(bashio::jq "${result}" '.external_url' | cut -d'/' -f3 | cut -d':' -f1)
hostname=$(bashio::info.hostname)

jq --arg internal "${internal}" --arg external "${external}" --arg hostname "${hostname}" \
    '{ssl: .ssl, require_ssl: .require_ssl, internal: $internal, external: $internal, hostname: $hostname}' \
    /data/options.json | tempio \
    -template /usr/share/cupsd.conf.tempio \
    -out /etc/cups/cupsd.conf

tempio \
    -conf /data/options.json \
    -template /usr/share/cups-files.conf.tempio \
    -out /etc/cups/cups-files.conf

/usr/sbin/cupsd -f