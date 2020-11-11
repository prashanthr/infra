# Node Image -- Alternatively can use https://github.com/keymetrics/docker-pm2/blob/master/tags/latest/jessie/Dockerfile
FROM node:current
# Labels & metadata
LABEL version="__DOCKER_IMAGE_VERSION__"
LABEL name="__DOCKER_IMAGE_NAME__"
LABEL description="__DOCKER_IMAGE_DESCRIPTION__"
LABEL maintainer="__DOCKER_IMAGE_MAINTAINER__"
# OS Upgrades & Dependencies
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install apt-utils -y && apt-get install net-tools vim curl -y 
RUN apt-get clean
# Install Yarn
# RUN npm install -g yarn
# Set env
ENV WORK_DIR=__DOCKER_WORKDIR__
ENV NODE_ENV=production
ENV PORT=__DOCKER_PORT__
# Workdir
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
# package handling
ADD package*.json ${WORK_DIR}
ADD yarn.lock ${WORK_DIR}
RUN yarn --${NODE_ENV}
# Install App Dependencies
COPY . ${WORK_DIR}
# Run application
CMD ["npm", "run", "start"]
# Expose port
EXPOSE ${PORT}
