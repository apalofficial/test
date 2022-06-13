ARG REGISTRY=staging.docker.akamai.com/images
FROM ${REGISTRY}/nginx
ARG component=.
ARG jobId=none
ARG BUILD_SYSTEM=local
COPY $component/sites/deploy.html /usr/share/nginx/html/index.html
RUN sed -i 's/    listen       80;/    listen       8081;/g' /etc/nginx/conf.d/default.conf
RUN sed -i "s/BUILD_SYSTEM/$BUILD_SYSTEM/g" /usr/share/nginx/html/index.html
RUN sed -i "s/JOB_ID/$jobId/g" /usr/share/nginx/html/index.html
