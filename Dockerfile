# v6.9.2
FROM node:boron

# Create app directory
RUN mkdir -p /usr/todos-elm
WORKDIR /usr/todos-elm

# Install dependencies
COPY package.json /usr/todos-elm
COPY elm-package.json /usr/todos-elm
RUN rm -rf node_modules
RUN npm install -g elm@0.18.0
RUN npm install

# Bundle app source inside image
COPY . /usr/todos-elm
RUN npm run build

# App binds to port 3000, map to docker daemon
EXPOSE 3000

# Define command to start app
CMD [ "npm", "start" ]
