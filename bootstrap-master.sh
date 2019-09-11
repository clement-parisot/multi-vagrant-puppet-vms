#!/bin/sh

# Run on VM to bootstrap Puppet Master server

if ps aux | grep "puppetserver" | grep -v grep 2> /dev/null
then
    echo "Puppet Master is already installed. Exiting..."
else
    # Install Puppet Master
    wget https://apt.puppetlabs.com/puppet5-release-bionic.deb && \
    sudo dpkg -i puppet5-release-bionic.deb && \
    sudo apt-get update -yq && sudo apt-get upgrade -yq && \
    sudo apt-get install -yq puppetserver

    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.5    puppet.example.com  puppet" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.10   node01.example.com  node01" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.20   node02.example.com  node02" | sudo tee --append /etc/hosts 2> /dev/null

    # Add optional alternate DNS names to /etc/puppet/puppet.conf
    sudo sed -i 's/.*\[main\].*/&\ndns_alt_names = puppet,puppet.example.com/' /etc/puppetlabs/puppet/puppet.conf

    # Install some initial puppet modules on Puppet Master server
    sudo /opt/puppetlabs/bin/puppet module install puppetlabs-ntp
    sudo /opt/puppetlabs/bin/puppet module install garethr-docker
    sudo /opt/puppetlabs/bin/puppet module install puppetlabs-git
    sudo /opt/puppetlabs/bin/puppet module install puppetlabs-vcsrepo
    sudo /opt/puppetlabs/bin/puppet module install garystafford-fig

    # symlink manifest from Vagrant synced folder location
    sudo ln -s /vagrant/cparisot /etc/puppetlabs/code/environments/
fi
