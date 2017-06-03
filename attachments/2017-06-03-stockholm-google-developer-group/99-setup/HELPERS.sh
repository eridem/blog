# Set up Server and Clients

nomad agent -config $HOME/nomad-server.nomad

nomad agent -config $HOME/nomad-client-01.nomad

nomad agent -config $HOME/nomad-client-01.nomad

# Run from my computer

export NOMAD_ADDR=http://node-01.eridem.net:4646

nomad server-members

nomad status

# Development mode

consul agent -dev
nomad agent -dev


# Script I used on a new Ubuntu node

sudo apt update; sudo apt-get -y install unzip apt-transport-https ca-certificates curl; \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - ; \
sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"; \
sudo apt-get update; \
sudo apt-get -y install docker-ce ; \

sudo usermod -aG docker eridem ; \

wget https://releases.hashicorp.com/nomad/0.5.6/nomad_0.5.6_linux_amd64.zip; \
    unzip nomad_0.5.6_linux_amd64.zip; \
    mkdir bin; \
    mv nomad bin; /
    rm nomad_0.5.6_linux_amd64.zip

ssh eridem@node-01.eridem.net
