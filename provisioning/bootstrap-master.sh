#!/usr/bin/env bash

sudo apt-get update

# Run on VM to bootstrap Puppet Master server

if ps aux | grep "puppet master" | grep -v grep 2> /dev/null
then
    echo "Puppet Master is already installed. Exiting..."
else
    # Install Puppet Master
    wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb && \
    sudo dpkg -i puppetlabs-release-trusty.deb && \
    sudo apt-get update -yq && sudo apt-get upgrade -yq && \
    sudo apt-get install -yq puppetmaster

    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.1.10.10   puppet.example.com  puppet" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.1.10.20   lb1.example.com     lb1"    | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.1.10.30   app1.example.com    app1"   | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.1.10.40   db1.example.com     db1"    | sudo tee --append /etc/hosts 2> /dev/null 
 
    # Add optional alternate DNS names to /etc/puppet/puppet.conf
    sudo sed -i 's/.*\[main\].*/&\ndns_alt_names = puppet,puppet.example.com/' /etc/puppet/puppet.conf
fi
