job "microservice-job" {
  type = "service"
  datacenters = ["dc1"]

  group "Microservices" {
    count = "1"
    
    # Microservice 01
    task "microservice-01" {
      driver = "docker"

      env {
        GREETING = "From Nomad!"
      }

      config {
        image = "microservice:1.0.0"
        labels {
          workshop = "2017-05-24"
          group = "Stockholm Google Development Group"
        }
        port_map {
          http = 3000
        }

        volumes = [
          "/tmp:/tmp"
        ]
        dns_servers = ["8.8.8.8", "8.8.4.4"]
        
        // command = "yarn"
        // args = [ "start" ]
        // network_mode = "bridge" (host | bridge | container:name)      
        // auth {
        //   username = "docker-user"
        //   password = "123456"
        //   server_address = "hub.docker.eridem.net"
        // }  
      }

      resources {
        memory = 128  # MB
        cpu    = 20   # MHz
        iops   = 0    # Weight

        network {
          mbits = 10  # Mbit
          port "http" {}
        }
      }

      service {
        name = "microservice-01"
        tags = ["nomad", "microservice-01", "1.0.0"]
        port = "http"

        check {
          name     = "alive"
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
