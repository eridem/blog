---
layout:     post
title:      "Multistage builds for NodeJS"
author:     "eridem"
main-img:   img/featured/2017-11-19-multistage-builds-for-nodejs.jpg
permalink:  multistage-builds-for-nodejs
---

With the new functionlity appear in **Docker 17.05**, we can have multistage builds in our Node application.

Using multistage builds, we can test and build our application with a single `Dockerfile` without compromise the security and making the builds faster.

![Multi-Stage Docker diagram](/img/posts/2017-11-19-multistage-builds-for-nodejs/diagram.png)

## Code structure 

Without go into code details, we have the following code structure:

```plain
+ lib/
+ tests/
- Dockerfile
- index.js
- package.json
- yarn.lock
```

- The folder `tests/` contains all our tests.
- The folders and files `lib/`, `index.js` and `package.json` are part of our application.

## Dockerfile

We will create a `Dockerfile` which has three stages:

- ***Build***: will copy all the files and install all production dependencies.
- ***Test***: it will install development dependencies and execute tests.
- ***Package***: it will prepare the final container to execture in production removing anything not needed.

Complete example:

```dockerfile
# Build
FROM node:9.2.0-alpine AS Build
WORKDIR /usr/src/app

ARG NPM_TOKEN
RUN echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > /root/.npmrc

COPY . .
RUN yarn --frozen-lockfile --production

# Test
FROM node:9.2.0-alpine AS Tests
WORKDIR /usr/src/app

COPY --from=Build /root/.npmrc /root/.npmrc
COPY --from=Build /usr/src/app ./
RUN yarn --frozen-lockfile

RUN yarn test

# Package
FROM node:9.2.0-alpine AS Package
WORKDIR /usr/src/app

COPY --from=Build /usr/src/app ./
RUN rm -rf tests/

ENTRYPOINT [ "yarn", "start" ]
```

### Notes

- Each build stage derivates from an image. We can use `AS <name>` to reference it inside our `Dockerfile` in future steps.
- We pass the `NPM_TOKEN` on build to install the dependencies.
- Using the command `COPY --from=<name>` we can copy files from previous containers referenced in our `Dockerfile`
- We only copy the `/root/.npmrc` to another stage if we need to install dependencies. The final container should not contain this file.
- We remove the `tests/` folder from the package step because those files are not needed.
