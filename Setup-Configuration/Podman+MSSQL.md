# [Install SQLServer on Podman](https://learn.microsoft.com/en-in/sql/linux/quickstart-install-connect-docker?view=sql-server-ver16&tabs=cli&pivots=cs1-bash)
https://computingpost.medium.com/run-microsoft-sql-server-in-podman-docker-container-7d270e9c97b0
https://vladdba.com/2024/09/07/create-sql-server-container-with-podman/

## Pull image and spin container
```
# Pull image
podman pull mcr.microsoft.com/mssql/server:2022-latest

# Create data directories
export MSSQL_DIRECTORY=/var/lib/mssql
# sudo rm -rf "${MSSQL_DIRECTORY}"
sudo mkdir -p "${MSSQL_DIRECTORY}"/{data,log,secrets}

# sudo chmod 777 -R "${MSSQL_DIRECTORY}"
sudo chown -R $USER:$USER "${MSSQL_DIRECTORY}"

# Prompt for password
read -s -p "Enter SA Password: " sa_password && export MSSQL_SA_PASSWORD="$sa_password"

# Run container
podman run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=${MSSQL_SA_PASSWORD}" \
    -p 1433:1433 --name sqlserver --hostname sqlserver \
    -v ${MSSQL_DIRECTORY}/data:/var/opt/mssql/data \
    -v ${MSSQL_DIRECTORY}/log:/var/opt/mssql/log \
    -v ${MSSQL_DIRECTORY}/secrets:/var/opt/mssql/secrets \
    -d \
    mcr.microsoft.com/mssql/server:2022-latest

# Verify the container
podman ps
podman ps -a

podman logs -f sqlserver

podman rm sqlserver

# Connect to Bash Shell of Container
    # Non-root user
podman exec -it sqlserver "bash"
    # As root user
podman exec -u 0 -it sqlserver "bash"

```

## Connect to SQLServer
```
# Connect to container as root user to make some changes
podman exec -u 0 -it sqlserver "bash"

# Create links
ln -s /opt/mssql-tools18/bin/sqlcmd /usr/local/bin/sqlcmd
ln -s /opt/mssql-tools18/bin/bcp /usr/local/bin/bcp

# Update binaries
apt update && apt upgrade && apt install curl

# Create home director for mssql
mkdir -p /home/mssql/
chown -R mssql:mssql /home/mssql/

exit

# Connect as normal user
podman exec -it sqlserver "bash"


sqlcmd -S localhost -U sa -C -P $MSSQL_SA_PASSWORD

select @@servername, @@version;
go

```

## Copy files
```
# Copy files from a container
docker cp <Container ID>:<Container path> <host path>

# Copy files into a container
docker cp <Host path> <Container ID>:<Container path>
```

## If required, start container at system startup
```
# Generate a systemd Unit File for the Container
podman generate systemd --name sqlserver --files --new

# Move the Service File to systemd Directory
mkdir -p ~/.config/systemd/user
mv container-sqlserver.service ~/.config/systemd/user/

# Enable and Start the Service
systemctl --user enable container-sqlserver.service
systemctl --user start container-sqlserver.service

# If you want the user services to run on system boot, you might need to enable lingering:
loginctl enable-linger $USER

```