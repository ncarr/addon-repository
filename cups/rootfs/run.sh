#!/usr/bin/with-contenv bashio

# Create links for certificates with CUPS' expected filenames
bashio::config.require.ssl

keyfile=$(bashio::config keyfile)
certfile=$(bashio::config certfile)
cafile=$(bashio::config cafile)
hostname=$(bashio::info.hostname)

mkdir -p /data/ssl

rm -f /data/ssl/site.crt
rm -f "/data/ssl/$hostname.key"
rm -f "/data/ssl/$hostname.crt"

if [ $cafile != null ] && [ -e "/ssl/$cafile" ]; then
    ln -s "/ssl/$cafile" /data/ssl/site.crt
fi

if bashio::config.true ssl; then
    ln -s "/ssl/$keyfile" "/data/ssl/$hostname.key"
    ln -s "/ssl/$certfile" "/data/ssl/$hostname.crt"
fi

# Get all possible hostnames from configuration
result=$(bashio::api.supervisor GET /core/api/config true || true)
internal=$(bashio::jq "${result}" '.internal_url' | cut -d'/' -f3 | cut -d':' -f1)
external=$(bashio::jq "${result}" '.external_url' | cut -d'/' -f3 | cut -d':' -f1)

# Fill config file templates with runtime data
jq --arg internal "${internal}" --arg external "${external}" --arg hostname "${hostname}" \
    '{ssl: .ssl, require_ssl: .require_ssl, internal: $internal, external: $external, hostname: $hostname}' \
    /data/options.json | tempio \
    -template /usr/share/cupsd.conf.tempio \
    -out /etc/cups/cupsd.conf

tempio \
    -conf /data/options.json \
    -template /usr/share/cups-files.conf.tempio \
    -out /etc/cups/cups-files.conf

mkdir -p /data/cups

# Wait for Avahi to start up
until [ -e /var/run/avahi-daemon/socket ]; do
  sleep 1s
done

# DEBUG
/usr/sbin/cupsd -ft

echo "test complete"

# DEBUG
sleep 120

# Start CUPS
/usr/sbin/cupsd -f
