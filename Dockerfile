FROM node:16.13-alpine

WORKDIR /usr/src/app 
COPY package*.json ./

RUN npm install --no-package-lock \
    && chown -R node:node /usr/src/app 
USER 1000

COPY . .

CMD ["node","server.js"]