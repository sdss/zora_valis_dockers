# Use an official Node.js runtime as the base image
FROM node:18.17-slim as build-stage

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY zora/package*.json ./

# Install app dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY ./zora .

# Copy the custom .env.docker file
COPY .env.docker .env.production

# Build the Vue.js app
RUN npm run build

