#!/bin/bash

sudo service elasticsearch stop
sudo apt-get remove --purge elasticsearch
sudo rm /usr/share/keyrings/elasticsearch-archive-keyring.gpg
sudo rm /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update
sudo rm -rf /var/lib/elasticsearch/
sudo rm -rf /etc/elasticsearch/
sudo apt-get autoremove
