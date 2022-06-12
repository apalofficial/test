FROM staging.docker.akamai.com/images/nginx
ARG component=.
COPY $component/sites/test.html /usr/share/nginx/html/index.html
RUN sed -i 's/    listen       80;/    listen       8080;/g' /etc/nginx/conf.d/default.conf
RUN sed -i "s/JOB_ID/$jobId/g" /usr/share/nginx/html/index.html
