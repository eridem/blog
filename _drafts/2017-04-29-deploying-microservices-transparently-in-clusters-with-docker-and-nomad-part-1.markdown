---
layout:     post
title:      "Deploying Microservices Transparently in Clusters with Docker and Nomad (part 1/4)"
author:     "eridem"
main-img:   "img/featured/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad.jpg"
permalink:  deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-1
---

## Sections

- 👉 ***Part 1: Configuring the nodes***
- Part 2: [Dockerizing microservices](/deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-2)
- Part 3: [Deploying with Nomad](/deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-3)
- Part 4: [Tricks with Nomad](/deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-4)

## Goal

***Nomad*** is a tool for managing a cluster of machines and running applications on them. It makes easy to decide what to deploy and which resources are needed abstracting the machines and locations. 

Our goal will be desploy services in nodes transparently. With transparently, I refer to the fact that we will not need to know in which machines those services has been deployed. As well, *Nomad* will choose the right node to set up a new service and be sure that service can consume the neccesary CPU and memory resources.

We will use ***Consul*** as service discovery because *Nomad* understand by default how to communicate with it and it will help us to add our microservices automatically into it.

You can download and install *Nomad*, *Consul* and *Docker* from the following links:

- Nomad: <https://www.nomadproject.io/downloads.html>
- Consul: <https://www.consul.io/downloads.html> 
  - For our demo, we will run `Consul` directly from Docker
- Docker: <https://www.docker.com/community-edition>

## Setup

Ideally, we should create the following infrastructure in production:

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/tutorial-full-setup.png)

But, for this tutorial, we will only set up one node with *Consul* and a *Nomad Server* all in the same machine to save some time and skip the autoscalling.

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/tutorial-setup.png)

- `node-01.local`: this node will have *Nomad Server* installed which will be our proxy to deploy the services through the rest of the nodes (`node-02.local` and `node-03.local`). We will install *Consul* on here for service discovery.
- `node-02.local` and `node-03.local`: those are the ones where our deployments will end up. Those have exactly the same configurations.

About the ports, we need to open the following ones:

- `4646-4648` for all nodes in the subnet.
- `8500` for the node `node-01.local` in the subnet.
- `1025-65536` for the nodes `node-02.local` and `node-03.local` in the subnet to interact with the microservices.
- `8500,4646` for `node-01.local` publically from your office IP and CI server if you want to access to the *Consul* interface from `http://node-01.local:8500` and interact with *Nomad* in order to deploy new services.

As well, be sure that the *Nomad* binary is installed in all nodes and *Consul* binary only on the `node-01.local`.

## `node-01.local`

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/node-01.png)


### Consul

For *Consul* we will start it directly with docker using:

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

If we come back to <http://node-01.local:8500> we will see that the *Nomad* server has been registered and it advertises using *http*, *rpc* and *serf*.

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/node-01-consul-nomad.png)

Now, from our own computer, we can test the connectivity like this:

```bash
$ NOMAD_ADDR=http://node-01.local:4646 nomad server-members

Name            Address      Port  Status  Leader  Protocol  Build  Datacenter  Region
node-01.global  12.34.56.78  4648  alive   true    2         0.5.6  dc1         global
```

## `node-02.local` and `node-03.local`

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

Then, we will start the clients in similar way than the server:

```bash
$ nomad agent -config=$HOME/nomad-server.nomad
```

![](img/posts/2017-04-29-deploying-microservices-transparently-in-clusters-with-docker-and-nomad/node-0203-consul-nomad.png)

## Next section

Part 2: [Dockerizing microservices](/deploying-microservices-transparently-in-clusters-with-docker-and-nomad-part-2)
