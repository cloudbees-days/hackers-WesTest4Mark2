FROM node:20-alpine AS builder
WORKDIR /app
RUN apk add --no-cache jq bash
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
RUN ./vulnerable-packages.sh

FROM nginx:1.27-alpine3.20
RUN apk update && apk upgrade && rm -rf /var/cache/apk/*
COPY --from=builder /app/dist /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
