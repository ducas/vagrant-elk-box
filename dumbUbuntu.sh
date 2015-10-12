#!/usr/bin/env bash

# Do the initial apt-get update
echo "Initial apt-get update..."
apt-get update

# Install puppet
echo "Configuring puppet..."
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb
sudo apt-get update

# Install Puppet
echo "Installing Puppet..."
sudo apt-get install -y puppet

echo "Puppet installed!"

# Install RubyGems for the provider
echo "Installing RubyGems..."
apt-get install -y rubygems 
gem install --no-ri --no-rdoc rubygems-update
update_rubygems
