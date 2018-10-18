FROM gvangool/nginx-src:1.14.0 AS builder
RUN cd /usr/src/nginx-${NGINX_VERSION} \
 && ./configure \
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


FROM ubuntu:18.04
# Install dependencies for nginx
RUN apt-get update && \
    apt-get install -y libc6 libpcre3 libssl1.1 zlib1g && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
# Make required directories
RUN mkdir -p /var/log/nginx /var/lib/nginx

COPY --from=builder /etc/nginx/ /etc/nginx/
COPY --from=builder /usr/share/nginx/ /usr/share/nginx/

CMD ["/usr/share/nginx/sbin/nginx"]
