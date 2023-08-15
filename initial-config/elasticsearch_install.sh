#!/bin/bash

echo "* Download Elasticsearch package"
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.9.0-amd64.deb

echo "* Install the software and save the output in a file"
dpkg -i elasticsearch*.deb >> /shared/elasticsearch/installation_output.txt

echo "* Adjust the Elasticsearch main configuration file"
sed -i 's/^#cluster.name: my-application/cluster.name: elk-cluster/' /etc/elasticsearch/elasticsearch.yml
sed -i "s/^#node.name: node-1/node.name: $HOSTNAME/" /etc/elasticsearch/elasticsearch.yml
sed -i "s/^#network.host: 192.168.0.1/network.host: [\"localhost\", \"$(hostname -I | cut -d " " -f 2)\"]/" /etc/elasticsearch/elasticsearch.yml
sed -i "s/^#http.port: 9200/http.port: 9200/" /etc/elasticsearch/elasticsearch.yml
sed -i "s/^xpack.security.enabled: true/xpack.security.enabled: false/" /etc/elasticsearch/elasticsearch.yml

echo "* Adjust the Java heap size"
echo "-Xms2g" > /etc/elasticsearch/jvm.options.d/jvm.options
echo "-Xmx2g" >> /etc/elasticsearch/jvm.options.d/jvm.options 

echo "* Start and enable elasticsearch.service"
systemctl daemon-reload
systemctl enable --now elasticsearch