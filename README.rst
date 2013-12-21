docker-nginx-src
================
Config
------
The nginx config is based on the default Ubuntu 12.04 nginx configuration.

Following modification were done::

  echo "daemon off;" >> nginx/nginx.conf

In the ``./configure`` statement, you can find other extensions you could
install. They're used in one of the Ubuntu packages (``nginx-full``,
``nginx-naxsi``, ``nginx-light``, …).

Usage
-----
This should be seen as a base package from which you can install/reconfigure
your nginx.

I suggest you also mount 2 volumes: one for the sites you want to enable host
and the second for the logs.

::

  mkdir -p ~/nginx/{logs,sites}
  docker run -v ~/nginx/logs:/var/log/nginx/ -v ~/ngnix/sites:/etc/nginx/sites-enabled gvangool/nginx-src


Example
~~~~~~~
To get a minimal nginx version::

  FROM gvangool/nginx-src:1.4.4
  RUN cd /usr/src/nginx-${NGINX_VERSION} && MODULESDIR=/usr/src/nginx-modules ./configure \
	    --prefix=/etc/nginx \
	    --conf-path=/etc/nginx/nginx.conf \
	    --error-log-path=/var/log/nginx/error.log \
	    --http-client-body-temp-path=/var/lib/nginx/body \
	    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
	    --http-log-path=/var/log/nginx/access.log \
	    --http-proxy-temp-path=/var/lib/nginx/proxy \
	    --lock-path=/var/lock/nginx.lock \
	    --pid-path=/var/run/nginx.pid \
	    --with-http_gzip_static_module \
	    --with-http_ssl_module \
	    --without-ipv6 \
	    --without-http_browser_module \
	    --without-http_geo_module \
	    --without-http_limit_req_module \
	    --without-http_limit_zone_module \
	    --without-http_memcached_module \
	    --without-http_referer_module \
	    --without-http_scgi_module \
	    --without-http_split_clients_module \
	    --with-http_stub_status_module \
	    --without-http_ssi_module \
	    --without-http_userid_module \
	    --without-http_uwsgi_module \
	    --add-module=$(MODULESDIR)/nginx-echo \
  RUN cd /usr/src/nginx-${NGINX_VERSION} && make && make install
