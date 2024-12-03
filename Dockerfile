# pull official base image
FROM node:18-alpine

# Declaring env
#ARG NODE_ENV=preprod
ENV NODE_ENV=${NODE_ENV}

# set working directory
WORKDIR /opt/backend

# install app dependencies
COPY package*.json ./

RUN npm install

# install EDITORJS
WORKDIR ./src/plugins
RUN apk update
RUN apk add git
RUN git clone https://github.com/melishev/strapi-plugin-react-editorjs.git

WORKDIR ./strapi-plugin-react-editorjs
RUN npm install

WORKDIR /opt/backend

# add app
COPY . .
COPY ./user-permissions/validation/auth.js ./node_modules/@strapi/plugin-users-permissions/server/controllers/validation/
COPY ./user-permissions/auth.js ./node_modules/@strapi/plugin-users-permissions/server/controllers/
COPY ./user-permissions/config.js ./node_modules/@strapi/utils/lib/

RUN npm run build
EXPOSE 1337

CMD ["npm", "start"]

