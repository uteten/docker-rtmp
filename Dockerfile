FROM centos
RUN yum update -y
RUN yum groupinstall -y "Development Tools"
RUN yum -y install pcre-devel zlib-devel openssl-devel unzip wget
WORKDIR /usr/local/src/
RUN wget http://nginx.org/download/nginx-1.14.2.tar.gz
RUN tar xvzf nginx-1.14.2.tar.gz
RUN wget https://github.com/arut/nginx-rtmp-module/archive/master.zip
RUN unzip master.zip
WORKDIR nginx-1.14.2
RUN ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master
RUN make
RUN make install


COPY etc/index.html /usr/local/nginx/html/
COPY etc/play2.html /usr/local/nginx/html/
COPY etc/play.html  /usr/local/nginx/html/
COPY etc/memo.html  /usr/local/nginx/html/
COPY etc/rtmp.conf  /usr/local/nginx/conf/
COPY etc/run.sh     /usr/local/nginx/sbin/
RUN mkdir /usr/local/nginx/html/live/
RUN cat /usr/local/nginx/conf/rtmp.conf >> /usr/local/nginx/conf/nginx.conf
RUN chmod 755 /usr/local/nginx/sbin/run.sh
CMD ["/usr/local/nginx/sbin/run.sh"]
