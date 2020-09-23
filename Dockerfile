FROM debian:stretch
MAINTAINER Ibere Luiz Di Tizio Junior <ibere.tizio@gmail.com>

<<<<<<< HEAD
ARG VERSION_SERVER=3.5.90-1
=======
ARG VERSION_SERVER=3.4.313-1
>>>>>>> cb294d435b4dd90284f18fae34d318602ebcc56f

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && apt-get update && \
    apt-get install -y --no-install-recommends gnupg2 apt-transport-https ca-certificates procps curl netcat sqlite3 locales && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen && dpkg-reconfigure --frontend noninteractive locales && \
    apt-get -qq clean

RUN curl -sL http://packages.netxms.org/netxms.gpg | apt-key add - && \
    echo "deb http://packages.netxms.org/debian/ stretch main" > /etc/apt/sources.list.d/netxms.list && \
    apt-get update && apt-get -y install libssl1.1 libzmq5 &&  \
    apt-get -y install netxms-server=$VERSION_SERVER netxms-dbdrv-sqlite3=$VERSION_SERVER && \
    apt-get clean && \
    mkdir -p /usr/share/netxms/default-templates && \
    mv /usr/share/netxms/templates/* /usr/share/netxms/default-templates/

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US \
    LC_ALL=en_US.UTF-8 \
    UNLOCK_ON_STARTUP=1 \
    UPGRADE_ON_STARTUP=1 \
    DEBUG_LEVEL=7

VOLUME /data

EXPOSE 4701
EXPOSE 514/udp

COPY ./docker-entrypoint.sh ./wait-for /

RUN  chmod 755 /docker-entrypoint.sh && chmod 755 /wait-for

CMD ["/docker-entrypoint.sh"]
