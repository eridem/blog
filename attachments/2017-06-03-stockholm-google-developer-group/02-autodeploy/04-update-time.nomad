job "microservice-job" {
  type = "service"
  datacenters = ["dc1"]

  # How many jobs will update in parallel
  update {
    max_parallel = 1
    stagger      = "15s"
  }

  group "Microservices" {
    count = "3"
    
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
  }
}
