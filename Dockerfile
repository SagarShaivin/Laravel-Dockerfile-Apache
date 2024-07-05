FROM alpine:3.14

RUN apk update && apk add apache2 php7 php7-fpm php7-opcache php7-pdo php7-common php7-mbstring php7-json php7-session php7-xml php7-tokenizer openrc
RUN mkdir -p /run/openrc && touch /run/openrc/softlevel
RUN rc-update add apache2 default
RUN rc-update add php-fpm7 default
WORKDIR /var/www/html

COPY . .

RUN chown -R apache:apache /var/www/html

RUN sed -i 's#DocumentRoot "/var/www/localhost/htdocs"#DocumentRoot "/var/www/html/public"#' /etc/apache2/httpd.conf && \
    sed -i 's#<Directory "/var/www/localhost/htdocs">#<Directory "/var/www/html/public">#' /etc/apache2/httpd.conf && \
    sed -i 's#AllowOverride None#AllowOverride All#' /etc/apache2/httpd.conf

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]