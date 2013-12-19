FROM ubuntu:12.04
MAINTAINER Gert Van Gool <gert@vangool.mx>

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Fix locales
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Enable universe
RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install nginx
RUN apt-get update && apt-get install nginx  -y && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install build-essential libc6 libpcre3 libpcre3-dev libpcrecpp0 libssl0.9.8 libssl-dev zlib1g zlib1g-dev lsb-base wget -y

# Compiling nginx
ENV NGINX_VERSION 1.4.4

RUN service nginx stop
RUN rm -f /etc/nginx/sites-enabled/default
RUN cd /usr/src/ && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN cd /usr/src/ && tar xf nginx-${NGINX_VERSION}.tar.gz
RUN cd /usr/src/nginx-${NGINX_VERSION} && ./configure \
    --with-http_ssl_module \
    --with-sha1=/usr/lib \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --without-http_fastcgi_module \
    --sbin-path=/usr/sbin \
    --conf-path=/etc/nginx/nginx.conf \
    --prefix=/etc/nginx \
    --error-log-path=/var/log/nginx/error.log && make && make install

ADD nginx.conf /etc/nginx/
ADD website.nginx /etc/nginx/sites-enabled

EXPOSE 80 443
ENTRYPOINT ["nginx"]
