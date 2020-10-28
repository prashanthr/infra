FROM rust:latest AS build
# Labels & metadata
LABEL version="__DOCKER_IMAGE_VERSION__"
LABEL name="__DOCKER_IMAGE_NAME__"
LABEL description="__DOCKER_IMAGE_DESCRIPTION__"
LABEL maintainer="__DOCKER_IMAGE_MAINTAINER__"
# Set env
ENV APP_ENV=production
ENV PORT=__DOCKER_PORT__
ENV APP_NAME=__DOCKER_APP_NAME__
ENV WORK_DIR=__DOCKER_WORKDIR__/${APP_NAME}
# Workdir
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
# App setup
COPY Cargo.toml Cargo.lock ./
COPY src ./src
# Build and install the application
RUN cargo build --release
RUN cargo install --path .
USER 1000
# Run application
CMD ["./target/release/__DOCKER_APP_NAME__"]
EXPOSE ${PORT}
