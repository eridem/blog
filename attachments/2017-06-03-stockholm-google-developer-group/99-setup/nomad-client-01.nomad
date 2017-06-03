bind_addr = "10.0.0.5"
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
    http =  "node-02.eridem.net"
    rpc  =  "node-02.eridem.net"
    serf =  "node-02.eridem.net"
}
