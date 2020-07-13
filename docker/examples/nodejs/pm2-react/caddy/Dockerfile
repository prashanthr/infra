# Node Image -- Alternatively can use https://github.com/keymetrics/docker-pm2/blob/master/tags/latest/jessie/Dockerfile
FROM node:current AS base
# Labels & metadata
LABEL version="version"
LABEL name="demo-app"
LABEL description="This is an image for demo-app"
LABEL maintainer="Author <https://github.com/author>"
# OS Upgrades & Dependencies
RUN apt-get update && apt-get dist-upgrade -y && apt-get install apt-utils -y && apt-get clean
# Install Yarn
RUN npm install -g yarn
# Set envs
ENV WORK_DIR=/var/www/deploy/app/
ENV NODE_ENV=production
ENV PORT=9000
# Workdir
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
# package handling
ADD package*.json ${WORK_DIR}
ADD yarn.lock ${WORK_DIR}
RUN yarn --${NODE_ENV}
# Install App Dependencies
COPY . ${WORK_DIR}
# List for confirmation
RUN ls -altr ${WORK_DIR}
# Build the front end assets
RUN yarn build

# Caddy
FROM caddy/caddy:alpine
# Set Env Again
ENV WORK_DIR=/var/www/deploy/app/
ENV NODE_ENV=production
ENV PORT=9000
# Copy caddyfile for service
COPY ./Caddyfile /etc/caddy/Caddyfile
# OS Upgrades & Dependencies
RUN apk update && apk upgrade -f
# Workdir
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
# Copy files from base
COPY --from=base ${WORK_DIR} ${WORK_DIR}
# Install node, npm, yarn again
RUN apk add nodejs npm -f --no-cache
RUN npm install -g yarn
# Yarn install
RUN yarn --${NODE_ENV}
# Start Caddy
RUN caddy start | tee ${WORK_DIR}/caddy.log
# Run service
CMD ["./node_modules/.bin/pm2-runtime", "start", "./ecosystem.json"]
# Expose port
EXPOSE ${PORT}
