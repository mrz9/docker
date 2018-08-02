#!/bin/bash
echo "启动docker环境";
echo "============================";
echo "正在启动mysql";
docker stop zmysql;
docker run -d -p 3307:3306 --rm --name zmysql -v /Users/mrz/Desktop/docker/mysql/data:/var/lib/mysql -v /Users/mrz/Desktop/docker/mysql/logs:/logs -v /Users/mrz/Desktop/docker/mysql/conf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=root mysql:5.6;

echo "正在启动php";
docker stop zphp;
docker run -d -p 9001:9000 --rm --name zphp -v "$PWD/www":/var/www/html -v "$PWD/php/www.conf":/usr/local/etc/php-fpm.d/www.conf -v "$PWD/php/php.ini":/usr/local/etc/php/php.ini -v "$PWD/php/logs":/logs --link zmysql:mysql php:zphp;

echo "正在启动nginx";
docker stop znginx;
docker run -d -p 81:80 --rm --name znginx -v "$PWD/www":/usr/share/nginx/html -v "$PWD/nginx":/etc/nginx -v "$PWD/nginx/logs":/logs --link zphp:php nginx;