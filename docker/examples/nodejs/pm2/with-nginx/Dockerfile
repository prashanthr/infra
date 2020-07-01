# Node Image -- Alternatively can use https://github.com/keymetrics/docker-pm2/blob/master/tags/latest/jessie/Dockerfile
FROM node:current
# Labels & metadata
LABEL version="nginx"
LABEL name="demo-app"
LABEL description="This is an image for demo-app"
LABEL maintainer "Author <https://github.com/author>"
# OS Upgrades & Dependencies
RUN apt-get update &&  apt-get dist-upgrade -y && apt-get clean && apt-get install apt-utils -y
# Install Yarn
RUN npm install -g yarn
# Set env
ENV WORK_DIR=/var/www/deploy/app/
ENV NODE_ENV=production
ENV APP_PORT=9000
ENV NGINX_PORT=9005
ENV NGINX_CONFIG_PATH=/etc/nginx/sites-available/default
# Workdir
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
# package handling
ADD package*.json ${WORK_DIR}
RUN yarn --${NODE_ENV}
# Install App Dependencies
COPY . ${WORK_DIR}
# Build the front end assets
RUN yarn build-app
# Install other deps
RUN apt-get install apt-transport-https lsb-release ca-certificates nginx net-tools vim -y
# Check versions
RUN nginx -v
# NGINX
COPY ./deploy/nginx/default.lua ${NGINX_CONFIG_PATH}
RUN nginx -t
# Run application
CMD ["./node_modules/.bin/pm2-runtime", "start", "ecosystem.json"]
# Reload NGINX
RUN service nginx start && service nginx reload
# Expose app to the world
EXPOSE ${NGINX_PORT}
