#!/bin/bash
set -e
if [ $# != 1 ];then
        echo "参数错误"
        echo "e.g:$0 {version}"
        exit 1
fi
version=$1
temp=/opt

yum -y install epel-release 
yum -y install gcc zlib zlib-devel pcre-devel openssl openssl-devel vim wget 

cd $temp && wget https://nginx.org/download/nginx-$version.tar.gz

if [ ! -f nginx-$version.tar.gz ];then
    echo "版本错误，请检查！！！" 
    exit 1
fi

tar xf nginx-$version.tar.gz
cd nginx-$version
./configure --with-http_ssl_module --with-http_v2_module --with-http_stub_status_module
make && make install
mkdir -p /usr/local/nginx/conf/{conf.d,upstream}

#初始化配置文件
cat>/usr/local/nginx/conf/nginx.conf<<EOF
#user  nobody;
worker_processes  4;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  10240;
    multi_accept on;
}


http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  logs/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             mime.types;
    default_type        application/octet-stream;

    server_tokens off;

    server_names_hash_bucket_size 128;
    client_header_buffer_size 32k;
    large_client_header_buffers 4 32k;
    client_max_body_size 50m;

    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 256k;

    gzip  on;
    gzip_buffers 4 8k;
    gzip_min_length 1k;
    gzip_http_version 1.1;
    gzip_comp_level 6;
    gzip_types text/plain application/javascript text/css application/xml text/javascript image/jpeg image/gif image/png application/x-font-ttf;
    gzip_disable "MSIE [1-6]\.";
	
	include conf.d/*.conf;
	include upstream/*.conf;
	
	#default_server
	server {
		listen 80 default_server;
		server_name _;
		access_log off;
		return 404;
	}
	
	#health_check
	server {
		listen 80;
		server_name xxx.xxx.xxx;
		access_log off;
		location / {
                default_type text/html ;
                return 200  'It works!';
        }
    }
    
}

EOF