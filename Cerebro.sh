
#!/bin/bash
# https://www.alibabacloud.com/help/en/es/use-cases/use-cerebro-to-access-an-elasticsearch-cluster
# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo "wget not found. Please install wget."
    exit 1
fi

# Check if tar is installed
if ! command -v tar &> /dev/null; then
    echo "tar not found. Please install tar."
    exit 1
fi

# Download Cerebro
wget https://github.com/lmenezes/cerebro/releases/download/v0.9.0/cerebro-0.9.0.tgz

# Extract Cerebro
tar -zxvf cerebro-0.9.0.tgz

# Navigate to Cerebro directory
cd cerebro-0.9.0

# Create a configuration file for Cerebro
cat <<EOF > conf/application.conf
# Secret will be used to sign session cookies, CSRF tokens and for other encryption utilities.
# It is highly recommended to change this value before running cerebro in production.
secret = "ki:s:[[@=Ag?QI\`W2jMwkY:eqvrJ]JqoJyi2axj3ZvOv^/KavOT4ViJSv?6YY4[N"

# Application base path
basePath = "/"

# Defaults to RUNNING_PID at the root directory of the app.
# To avoid creating a PID file set this value to /dev/null
pidfile.path = /dev/null

# Rest request history max size per user
rest.history.size = 50

# Path of local database file
data.path = "./cerebro.db"

play {
  # Cerebro port, by default it's 9000 (play's default)
  server.http.port = ${?CEREBRO_PORT}
}

es = {
  gzip = true
}

# Authentication
auth = {
  # either basic or ldap
  type: ${?AUTH_TYPE}
  settings {
    # LDAP
    url = ${?LDAP_URL}
    base-dn = ${?LDAP_BASE_DN}
    method = ${?LDAP_METHOD}
    user-template = ${?LDAP_USER_TEMPLATE}
    bind-dn = ${?LDAP_BIND_DN}
    bind-pw = ${?LDAP_BIND_PWD}
    group-search {
      base-dn = ${?LDAP_GROUP_BASE_DN}
      user-attr = ${?LDAP_USER_ATTR}
      user-attr-template = ${?LDAP_USER_ATTR_TEMPLATE}
      group = ${?LDAP_GROUP}
    }

    # Basic auth
    username = ${?BASIC_AUTH_USER}
    password = ${?BASIC_AUTH_PWD}
  }
}

# A list of known hosts
hosts = [
  {
    host = "http://35.183.41.21:9200"
    name = "MASTER-ELK-CLUSTER"
  }
]

EOF

# Create Cerebro systemd service file
cat <<EOF | sudo tee /etc/systemd/system/cerebro.service
[Unit]
Description=Cerebro - Elasticsearch Web Admin Tool
After=syslog.target network.target

[Service]
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/cerebro-0.9.0
ExecStart=/home/ubuntu/cerebro-0.9.0/bin/cerebro
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and restart Cerebro service
sudo systemctl daemon-reload
sudo systemctl restart cerebro
sudo systemctl enable cerebro

echo "------------ Use Cerebro to access an Elasticsearch cluster has been completed ------------"
