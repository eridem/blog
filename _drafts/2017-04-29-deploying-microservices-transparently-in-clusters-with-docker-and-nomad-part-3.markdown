---
layout:     post
title:      "Deploying Microservices Transparently in Clusters with Docker and Nomad (part 3/4)"
author:     "eridem"
main-img:   "img/featured/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad.jpg"
permalink:  deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-3
---

## Sections

- Part 1: [Configuring the nodes](/deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-1)
- Part 2: [Dockerizing microservices](/deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-2)
- 👉 ***Part 3: Deploying with Nomad***
- Part 4: [Tricks with Nomad](/deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-4)

## Jobs and Tasks

*Nomad* has a way to organize its entities. Those are jobs, tasks and services.

- ***Job*** is basically a set of configurations which will allow us to define how to trigger tasks or group of tasks.

- ***Task*** is the specifications about how to trigger an unit of work, such as a Docker container, a web application or a batch processing. Tasks can define which resources are needed to execute this unit of work, like network resources, CPU needed and so on. As well, they can define environment variables needed for this tasks and other metadata.

- ***Service*** is a subset of *Task* which defines that this task should be executed as a service in background.

If a *Job* has multiple *Task*, we can use *Group* to encapsulate more than one.

It exists other configurations, but this should give us an idea from now about the possibilities. We will use *Service* to define the deployment of our *Microservices*. This is basic representation of the concepts:

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/nomad-entities-diagram.png)

## Creating a job for our microservice

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

Job and task has different statuses. Running jobs does not guarantee that the task is running, so we can use the following command to obtain more information about its tasks:

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

Now we can see the allocations which represents the real status of the tasks and check its logs using the allocation ID:

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

If we would like to stop a *Job*, which represent a *Task* or a group of *Task*, we can stop them all using its name:

```bash
# Retreive jobs running
$ nomad status
    ID               Type     Priority  Status
    microservice-01  service  50        running

# Stop the job
$ nomad stop microservice-01
```

## Redeploying a job

