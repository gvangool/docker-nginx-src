FROM ubuntu:18.04
MAINTAINER Gert Van Gool <gert@vangool.mx>

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Enable main & universe as src repo's
RUN echo "deb-src http://archive.ubuntu.com/ubuntu bionic main universe\ndeb-src http://archive.ubuntu.com/ubuntu bionic-updates main universe\n" >> /etc/apt/sources.list

# Install build tools for nginx
RUN apt-get update && \
    apt-get install build-essential wget -y && \
    apt-get build-dep nginx-full -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV NGINX_VERSION 1.14.0

# Nginx
RUN cd /usr/src/ && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && tar xf nginx-${NGINX_VERSION}.tar.gz && rm -f nginx-${NGINX_VERSION}.tar.gz
# Extra modules
ADD modules /usr/src/nginx-modules/
ENV MODULESDIR /usr/src/nginx-modules
# Compiling nginx
RUN cd /usr/src/nginx-${NGINX_VERSION} && ./configure \
        --prefix=/usr/share/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --lock-path=/var/lock/nginx.lock \
        --pid-path=/run/nginx.pid \
        --modules-path=/usr/lib/nginx/modules \
        --http-client-body-temp-path=/var/lib/nginx/body \
        --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
        --http-proxy-temp-path=/var/lib/nginx/proxy \
        --http-scgi-temp-path=/var/lib/nginx/scgi \
        --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
        --with-debug \
        --with-pcre-jit \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_realip_module \
        --with-http_auth_request_module \
        --with-http_v2_module \
        --with-http_dav_module \
        --with-http_slice_module \
        --with-threads \
        --with-http_addition_module \
        --with-http_geoip_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_image_filter_module \
        --with-http_sub_module \
        --with-http_xslt_module \
        --add-module=${MODULESDIR}/http-auth-pam \
        --add-module=${MODULESDIR}/http-cache-purge \
        --add-module=${MODULESDIR}/http-echo \
        --add-module=${MODULESDIR}/http-upstream-fair \
        --add-module=${MODULESDIR}/http-subs-filter
# Other possible modules in ${MODULESDIR}

RUN cd /usr/src/nginx-${NGINX_VERSION} && make && make install
# Create the /var/lib/nginx directory (for temp paths)
RUN mkdir -p /var/lib/nginx

ADD nginx /etc/nginx/

EXPOSE 80 443
CMD ["/usr/share/nginx/sbin/nginx"]
