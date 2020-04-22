FROM nginx:1.17.6-alpine

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
EXPOSE 443