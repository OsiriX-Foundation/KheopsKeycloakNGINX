FROM nginx:1.19.6-alpine
RUN apk add inotify-tools certbot openssl
COPY entrypoint.sh /opt/nginx-letsencrypt.sh
COPY certbot.sh /opt/certbot.sh
RUN chmod +x /opt/nginx-letsencrypt.sh && \
    chmod +x /opt/certbot.sh

COPY nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["/opt/nginx-letsencrypt.sh"]

EXPOSE 80
EXPOSE 443
