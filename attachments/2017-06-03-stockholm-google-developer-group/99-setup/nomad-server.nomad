bind_addr = "0.0.0.0"
data_dir =  "/home/eridem/nomad-config/"
datacenter =  "dc1"

server = {
    enabled =  true

    bootstrap_expect =  1
}

consul =  {
    address = "node-01.eridem.net:8500"
}

advertise =  {
    http =  "node-01.eridem.net"
    rpc  =  "node-01.eridem.net"
    serf =  "node-01.eridem.net"
}
