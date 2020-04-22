#!/bin/sh
# based on https://ilhicas.com/2019/03/02/Nginx-Letsencrypt-Docker.html
# Create a self signed default certificate, so Ngix can start before we have
# any real certificates.

#Ensure we have folders available

if [[ ! -f /usr/share/nginx/certificates/fullchain_kheops.pem ]];then
    mkdir -p /usr/share/nginx/certificates
fi

### If we already have certbot generated certificates, copy them over
if [[ -f "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/keycloak.kheops.online/privkey.pem" ]]; then
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/keycloak.kheops.online/privkey.pem" /usr/share/nginx/certificates/privkey_kheops.pem
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/keycloak.kheops.online/fullchain.pem" /usr/share/nginx/certificates/fullchain_kheops.pem
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/keycloak.kheops.online/chain.pem" /usr/share/nginx/certificates/chain_kheops.pem
else
    openssl genrsa -out /usr/share/nginx/certificates/privkey_kheops.pem 4096
    openssl req -new -key /usr/share/nginx/certificates/privkey_kheops.pem -out /usr/share/nginx/certificates/cert_kheops.csr -nodes -subj \
    "/C=PT/ST=World/L=World/O=keycloak.kheops.online/OU=kheops/CN=keycloak.kheops.online"
    openssl x509 -req -days 365 -in /usr/share/nginx/certificates/cert_kheops.csr -signkey /usr/share/nginx/certificates/privkey_kheops.pem -out /usr/share/nginx/certificates/fullchain_kheops.pem
    cp /usr/share/nginx/certificates/fullchain_kheops.pem /usr/share/nginx/certificates/chain_kheops.pem
fi

### If we already have certbot generated certificates, copy them over
if [[ -f "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/login-lavim.unige.ch/privkey.pem" ]]; then
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/login-lavim.unige.ch/privkey.pem" /usr/share/nginx/certificates/privkey_unige.pem
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/login-lavim.unige.ch/fullchain.pem" /usr/share/nginx/certificates/fullchain_unige.pem
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/login-lavim.unige.ch/chain.pem" /usr/share/nginx/certificates/chain_unige.pem
else
    openssl genrsa -out /usr/share/nginx/certificates/privkey_unige.pem 4096
    openssl req -new -key /usr/share/nginx/certificates/privkey_unige.pem -out /usr/share/nginx/certificates/cert_unige.csr -nodes -subj \
    "/C=PT/ST=World/L=World/O=login-lavim.unige.ch/OU=kheops/CN=login-lavim.unige.ch"
    openssl x509 -req -days 365 -in /usr/share/nginx/certificates/cert_unige.csr -signkey /usr/share/nginx/certificates/privkey_unige.pem -out /usr/share/nginx/certificates/fullchain_kheops.pem
    cp /usr/share/nginx/certificates/fullchain_unige.pem /usr/share/nginx/certificates/chain_unige.pem
fi

### Send certbot Emission/Renewal to background
$(while :; do /opt/certbot.sh; sleep "${RENEW_INTERVAL:-12h}"; done;) &

### Check for changes in the certificate (i.e renewals or first start) and send this process to background
$(while inotifywait -e close_write /usr/share/nginx/certificates; do nginx -s reload; done) &

### Start nginx with daemon off as our main pid
nginx -g "daemon off;"
