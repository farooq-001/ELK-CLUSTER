#!/bin/bash

# Define variables
ELASTICSEARCH_DEB_FILE="elasticsearch-7.17.2-amd64.deb"
CLUSTER_NAME="ELK-CLUSTER"
NODE_NAME="ELK-NODE-1"
DATA_NODE=true
MASTER_NODE=true
NETWORK_HOST="172.31.23.88"
HTTP_PORT=9200

# Update package list
sudo apt update

# Upgrade installed packages
sudo apt upgrade -y

# Check if Elasticsearch package already exists
if [ -f "$ELASTICSEARCH_DEB_FILE" ]; then
    echo "Elasticsearch package already exists. Skipping download and installation."
else
    # Download and install Elasticsearch v7.17.2
    wget https://artifacts.elastic.co/downloads/elasticsearch/$ELASTICSEARCH_DEB_FILE
    sudo dpkg -i $ELASTICSEARCH_DEB_FILE
fi

# Reload systemd manager configuration
sudo systemctl daemon-reload

# Enable Elasticsearch service
sudo systemctl enable elasticsearch

# Edit Elasticsearch configuration file on machine
sudo sh -c "cat <<EOF > /etc/elasticsearch/elasticsearch.yml
#--------------------------------- Cluster Settings -----------------------------
# Use a descriptive name for your cluster:
cluster.name: $CLUSTER_NAME

#---------------------------------- Node Settings -------------------------------
# Use a descriptive name for the node:
node.name: $NODE_NAME
node.data: $DATA_NODE
node.master: $MASTER_NODE

# ----------------------------------- Memory -----------------------------------
# Lock the memory on startup:
#bootstrap.memory_lock: true

#-------------------------------- Network Settings -----------------------------
network.host: $NETWORK_HOST
http.port: $HTTP_PORT

#--------- Discovery Settings ---------
discovery.seed_hosts: ["172.31.23.88", "172.31.31.243", "172.31.20.58", "172.31.16.177"]
cluster.initial_master_nodes: ["172.31.23.88", "172.31.31.243", "172.31.20.58", "172.31.16.177"]

# ----------------------------------- Paths ------------------------------------
# Path to directory where to store the data (separate multiple locations by comma):
path.data: /var/lib/elasticsearch
# Path to log files:
path.logs: /var/log/elasticsearch

# ---------------------------------- Various -----------------------------------
# Require explicit names when deleting indices:
#action.destructive_requires_name: true
EOF"

echo "Elasticsearch configuration file has been updated successfully."
sleep 10
