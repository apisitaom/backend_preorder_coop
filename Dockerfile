FROM node:10

WORKDIR /home/node/app


COPY *package.json ./
COPY ./src ./src 

RUN npm install

EXPOSE 4000

CMD ["npm","run","start"]