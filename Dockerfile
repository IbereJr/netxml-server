FROM debian:buster
MAINTAINER Ibere Luiz Di Tizio Junior <ibere.tizio@gmail.com>

#ARG VERSION_SERVER=3.6.252

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && apt-get update && \
    apt-get install -y --no-install-recommends gnupg2 apt-transport-https ca-certificates procps curl vim netcat locales snmp && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen && dpkg-reconfigure --frontend noninteractive locales && \
    apt-get -qq clean

RUN curl -sL http://packages.netxms.org/netxms.gpg | apt-key add - && \
    echo "deb http://packages.netxms.org/debian/ buster main" > /etc/apt/sources.list.d/netxms.list && \
    apt-get update && apt-get -y install libssl1.1 libzmq5 &&  \
    apt-get -y install netxms-server=3.6.252-1 netxms-dbdrv-mysql=3.6.252-1 && \
    apt-get clean && \
    curl -O https://www.netxms.org/download/releases/3.6/nxshell-3.6.252.jar && \
    mkdir -p /usr/share/netxms/default-templates && \
    mv /usr/share/netxms/templates/* /usr/share/netxms/default-templates/

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US \
    LC_ALL=en_US.UTF-8 \
    UNLOCK_ON_STARTUP=1 \
    UPGRADE_ON_STARTUP=1 \
    DEBUG_LEVEL=7

VOLUME /data

EXPOSE 4701 4703
EXPOSE 514/udp

COPY ./docker-entrypoint.sh  /

RUN  chmod 755 /docker-entrypoint.sh 

CMD ["/docker-entrypoint.sh"]
