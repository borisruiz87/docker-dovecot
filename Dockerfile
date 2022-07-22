FROM alpine:latest

# instalando dovecot
RUN apk --no-cache add bash dovecot && rm -rf /var/cache/apk/*
 
# adicionando los archivos de configuracion para etc
COPY *.conf /etc/dovecot/conf.d/
COPY users /etc/dovecot/
COPY *.pem /etc/ssl/dovecot/
COPY *.key /etc/ssl/dovecot/

# creando usuario vmail y creando directorio para los correos
RUN adduser -H -D -s /sbin/nologin vmail && mkdir /srv/vmail && chown vmail:vmail /srv/vmail && chmod 770 /srv/vmail

EXPOSE 110 143 993 995

VOLUME ["/etc/dovecot", "/srv/vmail"]

CMD ["/usr/sbin/dovecot", "-F"]


