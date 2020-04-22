if [[ ! -f /var/www/certbot ]]; then
    mkdir -p /var/www/certbot
fi
## FIXME to only generate a single cert

certbot certonly \
        --config-dir "${LETSENCRYPT_DIR:-/etc/letsencrypt}" \
		--agree-tos \
		--domains "keycloak.kheops.online" \
		--email "spalte@naturalimage.ch" \
		--expand \
		--noninteractive \
		--webroot \
		--webroot-path /var/www/certbot \
		$OPTIONS || true

if [[ -f "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/keycloak.kheops.online/privkey.pem" ]]; then
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/keycloak.kheops.online/privkey.pem" /usr/share/nginx/certificates/privkey_kheops.pem
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/keycloak.kheops.online/fullchain.pem" /usr/share/nginx/certificates/fullchain_kheops.pem
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/keycloak.kheops.online/chain.pem" /usr/share/nginx/certificates/chain_kheops.pem
fi
certbot certonly \
        --config-dir "${LETSENCRYPT_DIR:-/etc/letsencrypt}" \
		--agree-tos \
		--domains "login-lavim.unige.ch" \
		--email "spalte@naturalimage.ch" \
		--expand \
		--noninteractive \
		--webroot \
		--webroot-path /var/www/certbot \
		$OPTIONS || true

if [[ -f "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/login-lavim.unige.ch/privkey.pem" ]]; then
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/login-lavim.unige.ch/privkey.pem" /usr/share/nginx/certificates/privkey_unige.pem
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/login-lavim.unige.ch/fullchain.pem" /usr/share/nginx/certificates/fullchain_unige.pem
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/login-lavim.unige.ch/chain.pem" /usr/share/nginx/certificates/chain_unige.pem
fi
