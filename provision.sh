#!/bin/bash

export LOCAL_NETWORK_IP='192.168.99.99'
export DOMAIN='d3vb0x.local'

vagrant up
vagrant provision
