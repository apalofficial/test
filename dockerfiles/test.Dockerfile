FROM staging.docker.akamai.com/images/nginx
ARG COMPONENT=.
COPY $COMPONENT/sites/test.html /usr/share/nginx/html/index.html
