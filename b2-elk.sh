#!/bin/bash

install_elasticsearch() {
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
# Add custom attributes to the nodede:
#node.attr.rack: r1
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
EOF"
}

uninstall_elasticsearch() {
    # Stop Elasticsearch service
    sudo systemctl stop elasticsearch

    # Disable Elasticsearch service
    sudo systemctl disable elasticsearch

    # Uninstall Elasticsearch package
    sudo apt remove --purge elasticsearch -y

    # Remove configuration files
    sudo rm -rf /etc/elasticsearch

    # Remove data and logs (adjust paths based on your setup)
    sudo rm -rf /var/lib/elasticsearch
    sudo rm -rf /var/log/elasticsearch

    # Reload systemd manager configuration
    sudo systemctl daemon-reload

    # Remove Elasticsearch package file
    sudo rm -f elasticsearch-7.17.2-amd64.deb

    echo "Elasticsearch has been uninstalled and configuration files removed."
}

# Main script
echo "Select an option:"
echo "1. Install Elasticsearch"
echo "2. Uninstall Elasticsearch"
read -p "Enter option number: " option

case $option in
    1)
        install_elasticsearch
        ;;
    2)
        uninstall_elasticsearch
        ;;
    *)
        echo "Invalid option. Exiting."
        ;;
esac
