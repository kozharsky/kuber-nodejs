FROM node:argon

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app


# Bundle app source
COPY project /usr/src/app

RUN npm test

EXPOSE 8080
CMD [ "node", "server.js" ]

