#!/bin/bash

echo "* Download Heartbeat package"
wget https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-8.9.0-amd64.deb

echo "* Install the software"
dpkg -i heartbeat-8.9.0-amd64.deb

echo "* Adjust the main config file"
cat > temp_file <<EOF
- type: icmp
  id: icmp-monitor
  name: ICMP Monnitor
  schedule: '*/30 * * * * * *'
  hosts: ["192.168.99.100", "192.168.99.101", "192.168.99.102"]
EOF

{ head -n 39 /etc/heartbeat/heartbeat.yml; cat temp_file; tail -n +39 /etc/heartbeat/heartbeat.yml; } > new_file

mv new_file /etc/heartbeat/heartbeat.yml

echo "* Disable the Elasticsearch ooutput and enable the Logstash output"
sed -i '107s/^/#/; 109s/^/#/' /etc/heartbeat/heartbeat.yml
sed -i '120s/^#//; 122s/^  *#/  /' /etc/heartbeat/heartbeat.yml

echo "* Check the configuration"
heartbeat test config

echo "* Install the beat teamplate in Elasticsearch"
heartbeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'

echo "* Start and enable heartbeat-elastic.service"
systemctl daemon-reload
systemctl enable --now heartbeat-elastic