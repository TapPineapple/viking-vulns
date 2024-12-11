#!/bin/bash

# I was going to use wireguard (cuz i'ts better)
# but as a client openvpn is pretty easy to use

SERVER=tapstation.net #update me
CLIENTNAME=vikings

docker compose run --rm openvpn ovpn_genconfig -u udp://$SERVER
docker compose run --rm openvpn ovpn_initpki

#Generate the config file for the clients (no pw)
docker compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
docker compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
