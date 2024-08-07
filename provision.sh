#!/bin/bash

# Update package list and install Java 8
sudo apt-get update
sudo apt install -y openjdk-8-jre-headless

# Remove other versions of Java if any
sudo apt-get remove --purge -y openjdk-11-jdk

# Set Java 8 as the default version
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac

# Update JAVA_HOME environment variable
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

# Verify the default Java version
java -version

# Download and install Nexus
cd /opt
sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo tar -zxvf latest-unix.tar.gz
sudo mv nexus-3* nexus

# Create nexus user and group
sudo adduser --disabled-login --no-create-home --gecos "" nexus

# Set ownership of Nexus directories to the nexus user
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work

# Configure Nexus to run as a service
sudo sed -i 's/#run_as_user=""/run_as_user="nexus"/' /opt/nexus/bin/nexus.rc

# Configure Nexus to run as a service
sudo tee /etc/systemd/system/nexus.service <<EOF
[Unit]
Description=Nexus Service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

# Enable and start Nexus service
sudo systemctl enable nexus
sudo systemctl start nexus
