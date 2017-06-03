bind_addr = "10.0.0.6"
data_dir =  "/home/eridem/nomad-config/"
datacenter =  "dc1"

client = {
    enabled =  true
    
    servers = ["node-01.eridem.net:4647"]
}

consul =  {
    address = "node-01.eridem.net:8500"
}

advertise =  {
    http =  "node-03.eridem.net"
    rpc  =  "node-03.eridem.net"
    serf =  "node-03.eridem.net"
}
