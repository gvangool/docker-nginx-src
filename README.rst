docker-nginx-src
================
Config
------
The nginx config is based on the default Ubuntu 18.04 nginx configuration.

Following modification were done::

  echo "daemon off;" >> nginx/nginx.conf

In the ``./configure`` statement, you can find other extensions you could
install. They're used in one of the Ubuntu packages (``nginx-full``,
``nginx-light``, …).

Usage
-----
This should be seen as a base package from which you can install/reconfigure
your nginx.

I suggest you only use this as a builder in your multistage containers

Example
~~~~~~~
To get a minimal nginx version::

  FROM gvangool/nginx-src:1.14.0 as builder
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
        --with-threads \
        --with-pcre-jit \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_realip_module \
        --with-http_auth_request_module \
        --with-http_v2_module \
        --with-http_slice_module \
        --with-http_gzip_static_module \
        --without-http_browser_module \
        --without-http_geo_module \
        --without-http_limit_req_module \
        --without-http_limit_conn_module \
        --without-http_memcached_module \
        --without-http_referer_module \
        --without-http_split_clients_module \
        --without-http_userid_module \
        --add-module=${MODULESDIR}/http-echo
  RUN cd /usr/src/nginx-${NGINX_VERSION} && make && make install

A full multi-stage example can be found in ``example/Dockerfile``.
