FROM alpine:latest

# instalando dovecot
RUN apk --no-cache add bash dovecot busybox-extras dovecot-lmtpd rsyslog tzdata supervisor && rm -rf /var/cache/apk/*
 
# adicionando los archivos de configuracion para etc
COPY ./conf/* /etc/dovecot/conf.d/
COPY ./ssl/* /etc/ssl/dovecot/
COPY quota-warning.sh /usr/local/bin/

# dando permisos de ejecucion
RUN chmod +x /usr/local/bin/quota-warning.sh

# incorporando la zona horaria de Cuba
RUN  cp /usr/share/zoneinfo/Cuba /etc/localtime

# creando la carpeta db para el archivo de autenticacion
RUN mkdir /etc/dovecot/db
COPY users /etc/dovecot/db/

# creando el grupo y el usuario vmail y creando directorio para los correos
RUN addgroup -g 5000 vmail && adduser -H -D -G vmail -u 5000 -s /sbin/nologin vmail && mkdir /srv/vmail && chown vmail:vmail /srv/vmail && chmod 770 /srv/vmail

EXPOSE 110 143 12345 24 12340

VOLUME ["/etc/dovecot/db/", "/srv/vmail", "/var/log/"]

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["sh","-c","/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
