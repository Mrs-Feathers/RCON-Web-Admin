FROM node:current-alpine as node

ENV NODE_ENV=production
ARG RCON_WEB_ADMIN_VERSION=0.14.1

WORKDIR /opt/rcon-web-admin

# Install git
RUN apk add --no-cache git

# Clone specific version of the repository
RUN git clone --depth 1 --branch ${RCON_WEB_ADMIN_VERSION} https://github.com/Mrs-Feathers/RCON-Web-Admin.git . || \
    git clone --depth 1 https://github.com/Mrs-Feathers/RCON-Web-Admin.git .

# Install dependencies
RUN npm ci && \
    npm cache clean --force

# Install production dependencies and core widgets
RUN npm install --production && \
    node src/main.js install-core-widgets && \
    chmod 0755 -R startscripts *

EXPOSE 80

VOLUME ["/opt/rcon-web-admin/db"]

ENV RWA_ENV=TRUE

ENTRYPOINT ["/usr/local/bin/node", "src/main.js", "start"]
