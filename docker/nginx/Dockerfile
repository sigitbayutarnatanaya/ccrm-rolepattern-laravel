# syntax=docker/dockerfile:experimental
# https://docs.docker.com/develop/develop-images/build_enhancements/

# Stage 1: Build NGINX-EE 
FROM debian:bullseye-slim as nginx-builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpcre3-dev \
    zlib1g-dev \
    libssl-dev \
    git \
    curl \
    wget \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/VirtuBox/nginx-ee.git /usr/src/nginx-ee
WORKDIR /usr/src/nginx-ee
RUN bash nginx-build.sh --full

# Stage 2: Final build
FROM nginx:alpine

# ENV for domain nginx
ENV APPLICATION_DOMAIN=example.com

# Copy image builder nginx-eee
COPY --from=nginx-builder /usr/src/nginx-ee /usr/local/nginx
COPY --from=nginx-builder /usr/src/nginx-ee/etc/nginx /etc/nginx
# RUN ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx

# Copy public build
COPY public /var/www/html/public

# Nginx config
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

# add user and group app
RUN addgroup -g 1001 app && \
    adduser -u 1000 -G app -s /bin/bash -D app

WORKDIR /var/www/html

# command seed server_name on nginx using env
CMD sh -c '\
    if [ -z "$APPLICATION_DOMAIN" ]; then \
        echo "ERROR: APPLICATION_DOMAIN environment variable is not set."; \
        exit 1; \
    fi; \
    sed -i "s/server_name .*/server_name $APPLICATION_DOMAIN;/" /etc/nginx/nginx.conf; \
    exec nginx -g "daemon off;"'