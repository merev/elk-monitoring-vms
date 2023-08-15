#!/bin/bash

echo "* Download Kibana package"
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.9.0-amd64.deb

echo "* Install the software"
dpkg -i kibana*.deb

echo "* Adjust the Kibana main configuration file"
sed -i 's/^#server.port: 5601/server.port: 5601/' /etc/kibana/kibana.yml
sed -i "s/^#server.host: \"localhost\"/server.host: \"$(hostname -I | cut -d " " -f 2)\"/" /etc/kibana/kibana.yml
sed -i "s/^#server.name: \"your-hostname\"/server.name: \"$HOSTNAME\"/" /etc/kibana/kibana.yml
sed -i "s|^#elasticsearch.hosts: \[\"http://localhost:9200\"\]|elasticsearch.hosts: \[\"http://localhost:9200\"\]|" /etc/kibana/kibana.yml

echo "* Start and enable kibana.service"
systemctl daemon-reload
systemctl enable --now kibana