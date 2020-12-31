ARG BUILD_FROM
FROM $BUILD_FROM

LABEL io.hass.version="1" io.hass.type="addon" io.hass.arch="armhf|aarch64|i386|amd64"

ENV LANG C.UTF-8

WORKDIR /usr/src
ARG HASSIO_AUTH_VERSION

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        vim \
        locales \
        whois \
        avahi-daemon \
        cups-bsd \
        printer-driver-all \
        printer-driver-gutenprint \
        hpijs-ppds \
        hp-ppd  \
        hplip \
        printer-driver-foo2zjs \
        musl \
        libcurl4 \
        libpam0g \
        musl-dev \
        libcurl4-openssl-dev \
        libpam0g-dev \
        gcc \
        git \
        make \
    && git clone --depth 1 -b $HASSIO_AUTH_VERSION https://github.com/home-assistant/hassio-auth \
    && cd hassio-auth/pam \
    && make \
    && cp -f pam_hassio.so /lib/security/ \
    && apt-get remove -y --purge \
        musl-dev \
        libcurl4-openssl-dev \
        libpam0g-dev \
        gcc \
        git \
        make \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -r /usr/src/hassio-auth

COPY etc-cups/cupsd.conf /etc/cups/cupsd.conf

EXPOSE 631

ENTRYPOINT ["/usr/sbin/cupsd", "-f"]
