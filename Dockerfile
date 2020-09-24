FROM centos:centos7
MAINTAINER Ibere Luiz Di Tizio Junior <ibere.tizio@gmail.com>

ARG VERSION_SERVER=3.5.90-1

RUN yum -y update
RUN yum groupinstall "Development Tools" -y    
RUN yum install wget openssl openssl-devel -y
RUN curl -O https://www.netxms.org/download/releases/3.5/netxms-3.5.90.tar.gz

RUN tar zxvf netxms-3.5.90.tar.gz
WORKDIR /netxms-3.5.90
RUN yum install libcurl libcurl-devel libssh libssh-devel -y
RUN yum install epel-release  -y
RUN yum install mosquitto mosquitto-devel  -y
RUN ./configure --with-server --with-sqlite --with-agent

RUN make
RUN make install

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
