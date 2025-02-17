#!/bin/bash

set -e  # Exit on error

# Set environment variables
export PGUSER="postgres"
export PGPASSWORD="devops123"
export PGDATABASE="mydb"

echo "Updating package lists..."
sudo apt update -y

echo "Installing required dependencies..."
sudo apt install -y wget gnupg2

echo "Adding PostgreSQL APT repository..."
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/postgresql.asc
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

echo "Updating package lists again..."
sudo apt update -y

echo "Installing PostgreSQL 16..."
sudo apt install -y postgresql-16

echo "Starting PostgreSQL service..."
sudo systemctl enable postgresql
sudo systemctl start postgresql

echo "Configuring PostgreSQL for public access..."
PG_CONF="/etc/postgresql/16/main/postgresql.conf"
HBA_CONF="/etc/postgresql/16/main/pg_hba.conf"

# Allow listening on all IPs
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

# Allow all connections from the local network (adjust subnet if needed)
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a "$HBA_CONF"
echo "host    all             all             ::/0                    md5" | sudo tee -a "$HBA_CONF"

echo "Restarting PostgreSQL service..."
sudo systemctl restart postgresql

echo "Updating password for postgres user..."
sudo -u postgres psql -c "ALTER USER postgres WITH ENCRYPTED PASSWORD '$PGPASSWORD';"

echo "Creating database (if not exists)..."
sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = '$PGDATABASE'" | grep -q 1 || sudo -u postgres psql -c "CREATE DATABASE $PGDATABASE;"

echo "Granting privileges to user 'postgres' on database '$PGDATABASE'..."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $PGDATABASE TO $PGUSER;"

echo "Generating configuration file..."
CONFIG_FILE="/etc/postgresql/16/main/db_config.conf"
sudo tee "$CONFIG_FILE" > /dev/null <<EOL
user: $PGUSER
password: $PGPASSWORD
database: $PGDATABASE
EOL

echo "PostgreSQL 16 installation and configuration completed!"
echo "Ensure port 5432 is open in your firewall for external access."
