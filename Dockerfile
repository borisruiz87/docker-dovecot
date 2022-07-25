FROM alpine:latest

# instalando dovecot
RUN apk --no-cache add bash dovecot busybox-extras dovecot-lmtpd && rm -rf /var/cache/apk/*
 
# adicionando los archivos de configuracion para etc
COPY *.conf /etc/dovecot/conf.d/
COPY users /etc/dovecot/
COPY *.pem /etc/ssl/dovecot/
COPY *.key /etc/ssl/dovecot/

# creando el grupo y el usuario vmail y creando directorio para los correos
RUN addgroup -g 5000 vmail && adduser -H -D -G vmail -u 5000 -s /sbin/nologin vmail && mkdir /srv/vmail && chown vmail:vmail /srv/vmail && chmod 770 /srv/vmail

EXPOSE 110 143 993 995 12345 24

VOLUME ["/etc/dovecot", "/srv/vmail"]

CMD ["/usr/sbin/dovecot", "-F"]


