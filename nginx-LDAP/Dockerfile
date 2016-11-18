FROM (image-location)/ubuntu14

MAINTAINER Vijay Ladla email:bishnuroy@gmail.com

ENV NGINX_VERSION release-1.10.1


RUN apt-get update -qy && \
    apt-get install --no-install-recommends -qy software-properties-common \
		ca-certificates \
		git \
		gcc \
		make \
		libpcre3-dev \
		zlib1g-dev \
		libldap2-dev \
		libssl-dev \
		wget

# See http://wiki.nginx.org/InstallOptions
RUN mkdir /var/log/nginx \
	&& mkdir /etc/nginx /etc/nginx/conf.d \
	&& cd ~ \
	&& git clone https://github.com/kvspb/nginx-auth-ldap.git \
	&& git clone https://github.com/nginx/nginx.git \
	&& cd ~/nginx \
	&& git checkout tags/${NGINX_VERSION} \
	&& ./auto/configure \
		--add-module=/root/nginx-auth-ldap \
		--with-http_ssl_module \
		--with-debug \
		--conf-path=/etc/nginx/nginx.conf \
		--sbin-path=/usr/sbin/nginx \
		--pid-path=/var/log/nginx/nginx.pid \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
	&& make install \
	&& cd .. \
	&& rm -rf nginx-auth-ldap \
	&& rm -rf nginx \
	&& wget -O /tmp/dockerize.tar.gz https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz \
	&& tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz \
	&& rm -rf /tmp/dockerize.tar.gz

COPY nginx.conf /etc/nginx/
COPY proxy-site.tmpl /

EXPOSE 80

CMD ["dockerize","-template","/proxy-site.tmpl:/etc/nginx/conf.d/proxy-site.conf","-stdout","/var/log/nginx/access.log","-stderr","/var/log/nginx/error.log","/usr/sbin/nginx"]
