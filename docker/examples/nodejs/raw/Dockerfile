# Node Image -- Alternatively can use https://github.com/keymetrics/docker-pm2/blob/master/tags/latest/jessie/Dockerfile
FROM node:current
# Labels & metadata
LABEL version="version"
LABEL name="demo-app"
LABEL description="This is an image for the demo-app"
LABEL maintainer "Author <https://github.com/author>"
# OS Upgrades & Dependencies
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install apt-utils -y && apt-get install net-tools vim curl -y 
RUN apt-get clean
# Install Yarn
RUN npm install -g yarn
# Set env
ENV WORK_DIR=/var/www/deploy/app/
ENV NODE_ENV=production
ENV PORT=9000
# Workdir
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
# package handling
ADD package*.json ${WORK_DIR}
RUN yarn --${NODE_ENV}
# Install App Dependencies
COPY . ${WORK_DIR}
# Run application
CMD ["npm", "run", "start"]
# Expose port
EXPOSE ${PORT}
