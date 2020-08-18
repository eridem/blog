---
layout:     post
title:      "Deploying Microservices Transparently in Clusters with Docker and Nomad"
author:     "eridem"
featured-image:   "img/featured/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad.jpg"
permalink:  deploying-microservices-transparently-in-clusters-with-docker-and-nomad
---

# Goal and Pre-requisites

***Nomad*** is a tool for managing a cluster of machines and running applications on them. It makes easy to decide what to deploy and which resources are needed abstracting the machines and locations. 

Our goal will be deploy services in nodes transparently. With transparently, I refer to the fact that we will not need to know in which machines those services has been deployed. As well, *Nomad* will choose the right node to set up a new service and be sure that service can consume the necessary CPU and memory resources.

We will use ***Consul*** as service discovery because *Nomad* understands by default how to communicate with it and it will help us to add our microservices automatically into it.

You can download and install *Nomad*, *Consul* and *Docker* from the following links:

- Nomad: <https://www.nomadproject.io/downloads.html>
- Consul: <https://www.consul.io/downloads.html> 
  - For our demo, we will run `Consul` directly from Docker
- Docker: <https://www.docker.com/community-edition>

# Part 1. Configuring the nodes

Ideally, we should create the following infrastructure in production:

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/tutorial-full-setup.png)

But, for this tutorial, we will only set up one node with *Consul* and a *Nomad Server* all on the same machine to save some time and skip the autoscaling.

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/tutorial-setup.png)

- `node-01.local`: this node will have *Nomad Server* installed which will be our proxy to deploy the services through the rest of the nodes (`node-02.local` and `node-03.local`). We will install *Consul* on here for service discovery.
- `node-02.local` and `node-03.local`: those are the ones where our deployments will end up. Those have exactly the same configurations.

About the ports, we need to open the following ones:

- `4646-4648` for all nodes in the subnet.
- `8500` for the node `node-01.local` in the subnet.
- `1025-65536` for the nodes `node-02.local` and `node-03.local` in the subnet to interact with the microservices.
- `8500,4646` for `node-01.local` publically from your office IP and CI server if you want to access to the *Consul* interface from `http://node-01.local:8500` and interact with *Nomad* in order to deploy new services.

Be sure that the *Nomad* is installed in all nodes and *Consul* binary only on the `node-01.local`. *Docker* only needs to be installed on the *Client* nodes.

## Setting up node-01.local

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/node-01.png)

### Consul

For *Consul* we will start it directly with *Docker* using:

```bash
$ docker run --net=host consul
```

At this moment, you should be able to reach <http://node-01.local:8500>.

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/node-01-consul.png)

### Nomad

We will create a file called `~/nomad-server.nomad` with the following content. I added comments on the code that keep following the tutorial inside the code:

```bash
# The binding IP of our interface
bind_addr = "0.0.0.0"

# Where all configurations are saved 
data_dir =  "/home/ubuntu/nomad-config/"
datacenter =  "dc1"

# Act as server. We will use this node to communicate with Nomad
# from other machines.
server =  {
    enabled =  true

    # The bootstrap_expected define how many Nomad server instances 
    # should be up running. We use only one for our tutorial, but 
    # in production we should have a odd number of instance 
    # running like 3, 5, ...
    bootstrap_expect =  1
}

# Where Consul, our service discovery, is listening from.
# For this tutorial, we are installing in the same place that 
# the Nomad server.
consul =  {
    address =  "node-01.local:8500"
}

# Addresses to notify Consul how to find us. In this case, we are
# accessible from the node-01.local domain
advertise =  {
    http =  "node-01.local"
    rpc  =  "node-01.local"
    serf =  "node-01.local"
}
```

Then, we will start *Nomad* using this configuration using its CLI tool:

```bash
$ nomad agent -config=$HOME/nomad-server.nomad
```

If we come back to <http://node-01.local:8500> we will see that the *Nomad* server has been registered and it advertises using *HTTP*, *RPC* and *SERF*.

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/node-01-consul-nomad.png)

Now, from our own computer, we can test the connectivity like this:

```bash
$ NOMAD_ADDR=http://node-01.local:4646 nomad server-members

Name            Address      Port  Status  Leader  Protocol  Build  Datacenter  Region
node-01.global  12.34.56.78  4648  alive   true    2         0.5.6  dc1         global
```

## Setting up node-02.local and node-03.local

The set up of the nodes which will host our services are not more difficult to set up. We need to run *Nomad* as client and connect it to the server one.

We will create a file called `~/nomad-client.nomad` with this content:

```bash
# The binding IP of our interface
# Can be found using 
# ifconfig eth0 | awk '/inet addr/ { print $2}' | sed 's#addr:##g'
bind_addr = "10.0.0.5"

# Where all configurations are saved 
data_dir =  "/home/ubuntu/nomad-config/"
datacenter =  "dc1"

# Act as client and communicate with the server one
client =  {
    enabled =  true

    # Server addresses. If we have more than one, we
    # can add them here
    servers = ["node-01.local:4647"]
}

# Where Consul, our service discovery, is listening from.
consul =  {
    address =  "node-01.local:8500"
}

# Addresses to notify Consul how to find us. 
# For this client, we are # accessible from 
# the node-02.local domain
advertise =  {
    http =  "node-02.local"
    rpc  =  "node-02.local"
    serf =  "node-02.local"
}
```

**NOTE**: replace `node-02.local` for `node-03.local` between the configurations of the clients.

Then, we will start the clients in a similar way than the server:

```bash
$ nomad agent -config=$HOME/nomad-server.nomad
```

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/node-0203-consul-nomad.png)

# Part 2. Dockerizing microservices

## Skiping this section?

If you already know how to Dockerize you can skip this section. You can use directly the example *Docker* image I prepared:

```bash
$ docker run -p 3000:3000 eridemnet/microservice-example:1.0.0
```

And be sure it works opening these two endpoints:

- <http://localhost:3000/>
- <http://localhost:3000/health>

## Dockerizing an example microservice

We will create a new example microservice and *dockerize* it. We will deploy it multiple times with different names because this will prove already how the approach works.

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

### `/health` endpoint

As we saw in the previous example, there is a special endpoint that can be fetched from <http://localhost:3000/health>. This endpoint will be useful to let *Consul* know that everything is up running on this microservice. We can do other checks on this endpoint, but so far an `ok` return should be enough.

### Dockerizing the microservice

In order to *dockerize* this service, we will use an `alpine` version of *Node.js* and expose the port `3000`.

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

Now you should be able to access again to <http://localhost:3000>, but in this case, the service is running inside the container.

### Deploying our image

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

# Part 3. Jobs and Tasks

## Jobs and Tasks

*Nomad* has a way to organize its entities. Those are jobs, tasks and services.

- ***Job*** is basically a set of configurations which will allow us to define how to trigger tasks or group of tasks.

- ***Task*** is the specifications about how to trigger a unit of work, such as a Docker container, a web application or a batch processing. Tasks can define which resources are needed to execute this unit of work, like network resources, CPU needed and so on. As well, they can define environment variables needed for this tasks and other metadata.

- ***Service*** is a subset of *Task* which defines that this task should be executed as a service in the background.

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/nomad-entities-diagram.png)

### Creating a job for our microservice

We will create a new file called `microservice-job-01.nomad` and define within a *Task* using *Docker* and be executed as a *Service*. The following code is self-explanatory:

```bash
job "microservice-01" {
  type = "service"
  datacenters = ["dc1"]

  group "Microservices" {

    # Number of services we want to deploy
    # of this type
    count = "1"
    
    task "microservice-01" {
      driver = "docker"

      config {
        # The image we want to use for deployment        
        image = "eridemnet/microservice-example:1.0.0"

        # The port exposed from the container
        port_map {
          http = 3000
        }
      }

      # Memory resources for this 
      resources {
        memory = 256 # 256MB
        network {
          mbits = "10"
          port "http" {}
        }
      }

      # Act as service
      service {
        name = "microservice-01"
        tags = ["microservice-01", "microservice-example@1.0.0"]
        port = "http"
      }
    }
  }
}
```

### Deploying our job

Let's finally run the job and deploy our service.

```bash
# Export the address of one Nomad server to use on the
# rest of commands
$ export NOMAD_ADDR=http://node-01.local:4664 

# Get current jobs, it should be empty because we did not deploy any
$ nomad status
    No running jobs

# We will deploy our services
$ nomad run microservice-job-01.nomad
    ==> Monitoring evaluation "d30beea8"
        Evaluation triggered by job "microservice-01"
        Allocation "cb3116cf" modified: node "a379fe1f", group "Microservices"
        Evaluation status changed: "pending" -> "complete"
    ==> Evaluation "d30beea8" finished with status "complete"

# And check the status of the jobs
$ nomad status
    ID               Type     Priority  Status
    microservice-01  service  50        running
```

Using the command `nomad run [file]` we deployed our service based on the configuration we defined previously. Running `nomad status` we can see that our job is running.

*Job* and *Task* have different statuses. Running jobs does not guarantee that the task is running, so we can use the following command to obtain more information about its tasks:

```bash
# Check the status of the task
$ nomad status microservice-01
    ID            = microservice-01
    Name          = microservice-01
    Type          = service
    Priority      = 50
    Datacenters   = dc1
    Status        = running
    Periodic      = false
    Parameterized = false

    Summary
    Task Group     Queued  Starting  Running  Failed  Complete  Lost
    Microservices  0       0         1        0       1         0

    Allocations
    ID        Eval ID   Node ID   Task Group     Desired  Status    Created At
    cb3116cf  d30beea8  a379fe1f  Microservices  run      running   05/14/17 19:19:26 CEST
```

Now we can see the allocations which represent the real status of the tasks and check its logs using the allocation ID:

```bash
# We pick up the allocation ID from the status command
$ nomad logs cb3116cf
    yarn start v0.23.4
    $ node .
```

We can receive more information from the running allocation using the command:

```bash
# We pick up the allocation ID from the status command
$ nomad alloc-status cb3116cf
    ID                  = cb3116cf
    Eval ID             = 1cf46e6d
    Name                = microservice-01.Microservices[0]
    Node ID             = a379fe1f
    Job ID              = microservice-01
    Client Status       = running
    Client Description  = <none>
    Desired Status      = run
    Desired Description = <none>
    Created At          = 05/14/17 19:19:26 CEST

    Task "microservice" is "running"
    Task Resources
    CPU        Memory          Disk     IOPS  Addresses
    0/100 MHz  48 MiB/256 MiB  300 MiB  0     http: 10.0.0.5:39357

    Recent Events:
    Time                    Type        Description
    05/14/17 19:19:48 CEST  Started     Task started by client
    05/14/17 19:19:26 CEST  Driver      Downloading image eridemnet/microservice-example:1.0.0
    05/14/17 19:19:26 CEST  Task Setup  Building Task Directory
    05/14/17 19:19:26 CEST  Received    Task received by client
```

As we can see, our microservice is listening on the port `39357`. But we can receive this information automatically from *Consul*:

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/consul-running-microservice-01.png)

Using this binding IP `10.0.0.5` we recognized that it refers to the `node-02.local` server. So we will try out:

```bash
$ curl http://node-02.local:59357
    Hello from microservice-01@1.0.0
```

And if we check again the logs from *Nomad*:

```bash
# Check logs from allocation
$ nomad logs cb3116cf
    yarn start v0.23.4
    $ node .
    Called to microservice-01@1.0.0 at Sun May 14 2017 17:44:39 GMT+0000 (UTC)
```

## Stopping a job

If we would like to stop a *Job*, which represents a *Task* or a group of *Task*, we can stop them all using its name:

```bash
# Retreive jobs running
$ nomad status
    ID               Type     Priority  Status
    microservice-01  service  50        running

# Stop the job
$ nomad stop microservice-01
```

## Modifying and planning jobs

We can modify our job files and redeploy them using `nomad run [file]`. But what if we want to see the consequences of the changes before deploying them?

For this example, we will modify our job `microservice-job-01.nomad` and modify the version of our *Docker* image:

```bash
        # The image we want to use for deployment        
        image = "eridemnet/microservice-example:1.0.1"
```

Now, we will ***plan*** which are the changes between our local without applying them using:

```bash
$ nomad plan microservice-job-01.nomad

    +/- Job: "microservice-01"
    +/- Task Group: "Microservices" (1 create/destroy update)
    +/- Task: "microservice" (forces create/destroy update)
        +/- Config {
        +/- image:             "eridemnet/microservice-example:1.0.0" => "eridemnet/microservice-example:1.0.1"
            port_map[0][http]: "3000"
            }

    Scheduler dry-run:
    - All tasks successfully allocated.

    Job Modify Index: 8843
    To submit the job with version verification run:

    nomad run -check-index 8843 job.nomad
```

As we can see, the microservice will upgrade from `1.0.0` to `1.0.1` in this line:

```bash
        +/- image:             "eridemnet/microservice-example:1.0.0" => "eridemnet/microservice-example:1.0.1"
```

Another thing that we can see is that *Nomad* creates a unique index to apply this specific plan. This will prevent to change the jobs accidentally and apply those changes by mistake:

```bash
$ nomad run -check-index 8843 job.nomad
    ==> Monitoring evaluation "041a2877"
        Evaluation triggered by job "microservice-01"
        Allocation "b3d82c0b" created: node "a379fe1f", group "Microservices"
        Evaluation status changed: "pending" -> "complete"
    ==> Evaluation "041a2877" finished with status "complete"
```

# Part 4. Problems with Nomad

There are few problems with *Nomad* at the current version (*0.5.6*) just when I wrote this article (*2017-05-27*). They may be solved at the time the reader reach this section.

## Services down on unexisting Docker image

If we run a job with an unexisting Docker image, *Nomad* will shut down the previous jobs and try to start the new ones. Once that *Nomad* realized that the image does not exist, it will not try to recover the previous ones, making your jobs unavailable and do not rolling back:

```bash
05/20/17 16:27:49 CEST  Restarting      Exceeded allowed attempts, applying a delay - Task restarting in 19.591207551s
05/20/17 16:27:49 CEST  Driver Failure  failed to initialize task "microservice" for alloc "e3f54673-ffc7-aa32-1b9e-6be18b0c2487": Failed to pull `eridemnet/microservice-example:non-existing`: API error (404): {"message":"manifest for eridemnet/microservice-example:non-existing not found"}
05/20/17 16:27:48 CEST  Driver          Downloading image eridemnet/microservice-example:non-existing
05/20/17 16:27:29 CEST  Restarting      Task restarting in 18.223988831s
```

We will not be able to see these changes on *Consul* because the previous instance was gratefully shut down.

If we increment our `count` property, this will still not working and we will see our jobs being shut down one by one.

## Do not wait for a health check

When we deploy a microservice, this may take a while to start. Maybe we are doing some initial checks, initializing a database or contacting other microservices before it is ready. Then we may decide to put our `/health` endpoint to return OK answers.

*Nomad* will not wait for this health check and kill instantly our previous versions.

The only way to resolve this issue is having our `count` to more than `1` and increment the `update.stagger` seconds to between updates so each instance has time enough to restart. This number of seconds is something we need to guess.

Could it not be good to have an old version running until the new one is healthy in *Consul*?

# More to discover

We only cover the few features that *Nomad* offers us. I hope the reader got inspiration enough to keep this *Nomad* journey for him/herself and try it out!
