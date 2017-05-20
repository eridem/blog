---
layout:     post
title:      "Deploying Microservices Transparently in Clusters with Docker and Nomad (part 2/4)"
author:     "eridem"
main-img:   "img/featured/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad.jpg"
permalink:  deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-2
---

## Sections

- Part 1: [Configuring the nodes](/deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-1)
- 👉 ***Part 2: Dockerizing microservices***
- Part 3: [Deploying with Nomad](/deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-3)
- Part 4: [Tricks with Nomad](/deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-4)

# Skiping this section?

If you already know how to Dockerize you can skip this section. You can use directly the example docker image I prepared:

```bash
$ docker run -p 3000:3000 eridemnet/microservice-example:1.0.0
```

And be sure it works opening these two endpoints:

- <http://localhost:3000/>
- <http://localhost:3000/health>

# Dockerizing an example microservice

We will create a new example microservice and dockerize it. We will deploy it multiple times with different names because this will prove already how the approach works.

We will use a small *Node.js* application. You need to have installed:

- Node.js: <https://nodejs.org/en/>
- Yarn: <https://yarnpkg.com/en/docs/install>

Then, we will create the following small microservice:

`package.json`

```json
{
  "name": "example-microservice",
  "version": "1.0.0",
  "description": "Microservice",
  "main": "index.js",
  "scripts": {
    "test": "standard",
    "start": "node ."
  },
  "license": "MIT",
  "dependencies": {
    "express": "^4.15.2"
  },
  "devDependencies": {
    "standard": "^10.0.2"
  }
}
```

`index.js`

```javascript
const express = require('express')
const packageInfo = require('./package.json')
const app = express()

app.get('/health', function(req, res) {
  res.send('ok')
})

app.get('/', function(req, res) {
  console.log(`Called to ${packageInfo.name}@${packageInfo.version} at ${new Date().toString()}`)
  
  res.send(`Hello from ${packageInfo.name}@${packageInfo.version}`)
});

app.listen(process.env.PORT || 3000)
```

Then, we can run it like this:

```bash
# Install dependencies
$ yarn

# Run it
$ yarn start
```

We can open the browser and test it using <http://localhost:3000>.

## `/health` endpoint

As we saw in the previous example, there are a special endpoint that can be fetched from <http://localhost:3000/health>. This endpoint will be useful to let *Consul* know that everything is up running on this microservice. We can do other checks on this endpoint, but so far an `ok` return should be enough.

# Dockerizing the microservice

In order to dockerize this service, we will use an `alpine` version of *Node.js* and expose the port `3000`.

`Dockerfile`

```dockerfile
FROM node:alpine

RUN mkdir -p /workdir
COPY ./package.json ./yarn.lock /workdir/

RUN cd /workdir && yarn
COPY * /workdir/

EXPOSE 3000
WORKDIR /workdir

ENTRYPOINT yarn start
```

Now we will be able to build and run this service from a container:

```bash
# Build image
$ docker build -t microservice-01 .

# Run image
$ docker run --rm -p 3000:3000 microservice-01
```

Now you should be able to access again to <http://localhost:3000>, but in this case the service is running inside the container.

# Deploying our image

To make this tutorial easier, we will deploy our container publically to the official Docker Hub <https://hub.docker.com>. *Nomad* has options to use credentials for private Docker repositories, but those are easy to set up and does not give much more value to this tutorial.

Be sure you create an account in <https://hub.docker.com> and create a repository named `microservice-example`.

Then, we can deploy our image (I will use my username `eridemnet` in the example):

```bash 
# Login into our account
$ docker login

# Build image
$ docker build -t eridemnet/microservice-example:1.0.0 .

# Push the image to the repository
$ docker push eridemnet/microservice-example:1.0.0
```

After few seconds, your image should be placed on your hub (using your username): <https://hub.docker.com/r/eridemnet/microservice-example/tags/>

# Next section

Part 2: [Deploying with Nomad](/deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-3)
