FROM staging.docker.akamai.com/images/nginx
ARG component=.
ARG jobId
COPY $component/sites/deploy.html /usr/share/nginx/html/index.html
RUN sed -i 's/    listen       80;/    listen       8081;/g' /etc/nginx/conf.d/default.conf
RUN sed -i "s/JOB_ID/$jobId/g" /usr/share/nginx/html/index.html
