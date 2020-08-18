---
layout:     post
title:      "Quick start with Hashicorp Terraform, infrastructure as code"
author:     "eridem"
featured-image:   img/featured/2017-09-17-quick-start-with-hashicorp-terraform-infrastructre-as-code.jpg
permalink:  infrastructure-as-code-replace-custom-terminal-scripts-and-uis
---

*Terraform* emerged as a tool to define infrastructure as code. You can define resources that your infrastructure needs from a single server to entire local or cloud datacenters.

| Advantage | Description |
|:-|:-
| **Version Control** | Be able to revise the history of changes done in the infrastructure with the possibility of rollback in some cases
| **Skip manual changes** | All changes are based on code. We will never forget which operations we did on the past if we want to recreate the same infrastructure
| **Self documented** | The infrastructure is defined in the code. It is not needed to revise it manually on the servers, databases, services, ...
| **Easily accessible** | Because it is easier to understand code, the infrastructure does not become *magic* to a bigger group of developers
| **Speed** | It is faster to write changes in code than go into the resources and do the changes manually one by one using terminals, ssh connections, UIs, ...

During this tutorial we will explain the bases to start working with *Terraform*. We will not cover all you can do, but once you learn these concepts, you will be able to move easily through its documentation in order to create more advanced code.

- [Variables](#variables): basic on any language in order to personalize our code.
- [Providers](#providers): configuration and connection to any service supported currently.
- [Resources](#resources): the main section of *Terraform* in order to create, modify and delete them.
- [Data Source](#data-sources): fetch existing information about resources and configurations from the code.
- [Planning our infrastructure](#planning-our-infrastructure): create *dry* plans in order to see what changes will be applied to our infrastructure without modify it.

## Quick example

**Prerequisite**: Install the CLI tool from [here](https://www.terraform.io/downloads.html) and make it available in your `PATH`.

```sh
variable "aws_access_key" {}
variable "aws_secret_key" {}

# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-west-1"
}

# Create a web server
resource "aws_instance" "web" {
  count         = 1
  ami           = "ami-785db401"
  instance_type = "t2.micro"

  tags {
    Name = "My instance created by Terraform"
  }
}

```

Save the content in a file called `my-infrastructure.tf` and using a terminal, write the following commands:

```sh
$ terraform init
$ terraform apply
    var.aws_access_key
    Enter a value: ...

    var.aws_secret_key
    Enter a value: ...
```

The CLI tool will ask you to fill the variables for your `aws_access_key` and your `aws_secret_key` and then, it will create this instance in AWS EC2.

![Creting EC2 instance from Terraform](img/posts/2017-09-17-quick-start-with-hashicorp-terraform-infrastructre-as-code/creating-ec2-first-demo.jpg)

## Variables

As infrastructure as a code, you can write variables. It is possible to create ***Strings***, ***Maps*** or ***Lists***. Booleans and numbers are converted to string types. We will cover only the basic ones which are used most of the time.

```sh
# String variable
variable "instance_name" {
  default = "My instance created by Terraform"
}

# Number variable
variable "number_of_instances" {
  default = 1
}

# Boolean variable
variable "is_available" {
  default = true
}
```

We can use the variables anywhere using the `${var.<variable-name>}` syntax. For instance:

```sh
...
  Name = "${var.instance_name}"
...
```

Variables can be changed outside the code. This give us ability to modify the values outside the code, for example from the Continuous Integration tool. You can do it in three ways:

| Method | Example |
|:-|:-
| CLI tool option `-var` | `terraform <command> -var instance_name="My nice name"`
| Environment variable that starts with `TF_VAR_` | `TF_VAR_instance_name="My nice name" terraform <command>`
| Removing `default` value and be asked | <code>terraform &lt;command&gt;<br />&nbsp;&nbsp;var.instance_name<br />&nbsp;&nbsp;Enter a value:</code>

## Providers

*Providers* are the services and configurations that will allow us to get, create, modify and delete resources. Each *Provider* is different and it will require different configurations.

**Examples**: we may want to set up AWS or Azure credentials, a connection to Postgresql or GitHub, the credentials to 1&1, etc.

```sh
provider "name" {
  # ... configuration ...
}
```

You can find all *Providers* in <https://www.terraform.io/docs/providers/index.html>.

```sh
# Example of provider to connect to GitHub
provider "github" {
  token        = "..."
  organization = "..."
}

# Example of provider to connect to Google Cloud
provider "google" {
  credentials = "..."
  project     = "..."
  region      = "..."
}
```

![Terraform Provider Logos](img/posts/2017-09-17-quick-start-with-hashicorp-terraform-infrastructre-as-code/provider-logos.jpg)

## Resources

*Resources* are the components of your infrastructure. They have dependencies on the *Providers* which contains the configuration and/or authentication to create them.

**Examples**: create a Azure Virtual Machine, add a DNS record, create a Heroku app, start a Docker container, create a new RabbitMQ queue, create a S3 resource in AWS, etc.

```sh
resource "resource_name" "name" {
  # ... configuration ...
}
```

Like the *Providers*, it requires read the documentation about each one. When choosing a *Provider* from the [Terraform Providers page](https://www.terraform.io/docs/providers/index.html), you will see a section related with the *Resources* that this *Provider* allows.

```sh
# Configure the Datadog provider
provider "datadog" {
  api_key = "${var.datadog_api_key}"
  app_key = "${var.datadog_app_key}"
}

# Create a new Datadog monitor
resource "datadog_monitor" "my_monitor" {
  name               = "Name for monitor foo"
  type               = "metric alert"
  message            = "Monitor triggered. Notify: @hipchat-channel"
  escalation_message = "Escalation message @pagerduty"

  query = "avg(last_1h):avg:aws.ec2.cpu{environment:foo,host:foo} by {host} > 2"

  # ...
}
```

All *Resource* outputs any kind of information which can be used in other parts of our infrastructure. For instance, we may want to use the `id` of a created *Resource* in order to create or connect another one. We will use the syntax `${<resource_name>.<custom_name>.<attribute>}`

```sh
provider "aws" {
  # ...
}

# Resource for a AWS AMI
resource "aws_ami" "my_nice_ami" {
  # ...
}

# Use previous AMI to create an EC2
resource "aws_instance" "my_nice_server" {
  ami = "${aws_ami.my_nice_ami.id}"
  # ...
}
```

## Data Sources

*Data Sources* are similar to *Resources* but they are used to fetching resources, not create them. Once that the information is obtained, they export their results in variables that we can use along our code in the form of `${data.<data_name>.<custom_name>.<attribute>}`. In the same way, they have dependencies on the *Provider* block to obtain its configuration.

**Examples**: obtain key/value values from Consul, get the IPs of an A record in the DNS, get the ID of a DB snapshot, etc.

```sh
data "data_name" "name" {
  # ...
}
```

Like the *Resources*, each *Data Source* configuration can be found under its *Provider* from the [Terraform Providers page](https://www.terraform.io/docs/providers/index.html)

```sh
provider "aws" {
  # ...
}

# Get latest snapshot from an identifier
data "aws_db_snapshot" "my_db_snapshot" {
    most_recent = true
    db_instance_identifier = "my_snapshot_identifier"
}

# You can do anything with the db snapshot id now using the syntax
# ${data.aws_db_snapshot.my_db_snapshot.id}

# Or other attributes documented on the Terraform pages
```

## Planning our infrastructure

*Terraform* reads from files with `.tf` extension. You can create as many as you would like inside the same folder. You cannot create subfolders with *Terraform* due they are reserved to create modules, which are not covered from this tutorial, but using the concepts learned in this tutorial it should be easy to [create one](https://www.terraform.io/docs/configuration/modules.html).

As example, this could be the structure for a project related with an `AWS` infrastructure:

```sh
+ ami.tf
+ aim.tf
+ instances.tf
+ rds.tf
+ subnets.tf
+ variables.tf
```

Once that we have our code written, we need to initialize our project, which will download the necessary components to interact with our *Providers*.

```sh
terraform init
```

*Terraform* have a ***planning*** phrase which allow us to see the changes in our infrastructure without apply them. We will use the command `plan`.

```sh
terraform plan -out=terraform.plan
```

This will create a binary file called `terraform.plan` that we can use in the next steps to apply the infrastructure. This file is important to keep the plan intact in case we do modifications to our files by mistake before apply them. It is possible to share this file with workmates or a CD tool in order to double check the changes to apply.

As example, I want to create a new EC2 instance and the `plan` command prints me the following message:

```sh
+ aws_instance.web
    ami:                          "ami-785db401"
    associate_public_ip_address:  "<computed>"
    availability_zone:            "<computed>"
    ebs_block_device.#:           "<computed>"
    ephemeral_block_device.#:     "<computed>"
    instance_state:               "<computed>"
    instance_type:                "t2.micro"
    ipv6_address_count:           "<computed>"
    ipv6_addresses.#:             "<computed>"
    key_name:                     "<computed>"
    network_interface.#:          "<computed>"
    network_interface_id:         "<computed>"
    placement_group:              "<computed>"
    primary_network_interface_id: "<computed>"
    private_dns:                  "<computed>"
    private_ip:                   "<computed>"
    public_dns:                   "<computed>"
    public_ip:                    "<computed>"
    root_block_device.#:          "<computed>"
    security_groups.#:            "<computed>"
    source_dest_check:            "true"
    subnet_id:                    "<computed>"
    tags.%:                       "1"
    tags.Name:                    "My instance created by Terraform"
    tenancy:                      "<computed>"
    volume_tags.%:                "<computed>"
    vpc_security_group_ids.#:     "<computed>"

Plan: 1 to add, 0 to change, 0 to destroy.
```

Once we are ready and satisfied with the changes, we use the command `apply` to apply the changes:

```sh
terraform apply terraform.plan
```

## What now?

After this tutorial you should be able to know how to initialize *Providers*, fetch data from them and create/modify or delete resources. You can do experiments with them and be creative in the way they are connected.

Examples of integrations/resources:

- Create CNAME records based on EC2 server IPs.
- Create Datadog monitors based on Docker containers running.
- Create and connect subnets between your instances.
- Apply GitHub branch protections to your repositories.
- ...

Learn ways to organize your infrastructure projects with:

- [Workspaces](https://www.terraform.io/docs/state/workspaces.html)
- [Modules](https://www.terraform.io/docs/configuration/modules.html)

Sync your project state accross different teams with:

- [States](https://www.terraform.io/docs/state/index.html)

And finally create your own plugins:

- [Plugins](https://www.terraform.io/docs/plugins/basics.html)
