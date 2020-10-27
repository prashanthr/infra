FROM rust:latest AS build
# Labels & metadata
LABEL version="__DOCKER_IMAGE_VERSION__"
LABEL name="__DOCKER_IMAGE_NAME__"
LABEL description="__DOCKER_IMAGE_DESCRIPTION__"
LABEL maintainer="__DOCKER_IMAGE_MAINTAINER__"
# Set env
ENV WORK_DIR=__DOCKER_WORKDIR__
ENV APP_ENV=production
ENV PORT=__DOCKER_PORT__
ENV APP_NAME=__DOCKER_APP_NAME__
# Workdir
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
# Download the target for static linking.
RUN rustup target add x86_64-unknown-linux-musl
# App
WORKDIR ${WORK_DIR}/${APP_NAME}
COPY Cargo.toml Cargo.lock ./
RUN cargo build --release
# Copy the source and build the application.
COPY src ./src
RUN cargo install --target x86_64-unknown-linux-musl --path .
# Copy the statically-linked binary into a scratch container.
FROM scratch
ENV DIST_PATH=/usr/local/cargo/bin
ENV APP_NAME=__DOCKER_APP_NAME__
ENV APP_ENV=production
COPY --from=build ${DIST_PATH}/${APP_NAME} .
USER 1000
CMD ["./$APP_NAME"]
