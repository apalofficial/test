FROM staging.docker.akamai.com/images/nginx
ARG COMPONENT=.
COPY $COMPONENT/sites/deploy.html /usr/share/nginx/html/index.html
