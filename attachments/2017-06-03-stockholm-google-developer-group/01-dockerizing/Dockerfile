FROM node:alpine
MAINTAINER "Miguel A. Dominguez <m@eridem.net>"

# Install dependencies
RUN mkdir -p /workdir
COPY ./package.json ./yarn.lock /workdir/
RUN cd workdir && yarn --production
COPY * /workdir/

# Environment variable
ENV GREETING NotSet

# Expose port
EXPOSE 3000

# Start the application
WORKDIR /workdir
ENTRYPOINT yarn start
