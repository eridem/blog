job "microservice-job" {
  type = "service"
  datacenters = ["dc1"]

  group "Microservices" {
    count = "1"

    # Microservice 01    
    task "microservice-01" {
      driver = "docker"

      config {
        image = "microservice:1.0.0"
        port_map {
          http = 3000
        }
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

    # Microservice 02    
    task "microservice-02" {
      driver = "docker"

      config {
        image = "microservice:1.0.0"
        port_map {
          http = 3000
        }
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
        name = "microservice-02"
        tags = ["nomad", "microservice-02", "1.0.0"]
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
