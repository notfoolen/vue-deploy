FROM node:18.7.0-alpine3.15
ARG MODE

WORKDIR /app
ADD package.json yarn.lock /app/
RUN apk add --no-cache git
RUN yarn install
ADD . .

RUN yarn build

FROM nginx:stable
ARG source
COPY --from=0 /app/dist/ /var/www/
RUN echo 'server { listen 80; root /var/www; index index.html; index index.html; location / { try_files $uri $uri/ /index.html?$args; } }' > /etc/nginx/conf.d/default.conf
