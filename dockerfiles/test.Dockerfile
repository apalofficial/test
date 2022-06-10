FROM staging.docker.akamai.com/images/nginx
ARG component=.
COPY $component/sites/test.html /usr/share/nginx/html/index.html
