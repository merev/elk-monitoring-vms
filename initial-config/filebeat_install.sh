#!/bin/bash

echo "* Download Filebeat package"
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.9.0-amd64.deb

echo "* Install the software and save the output in a file"
dpkg -i filebeat-8.9.0-amd64.deb

echo "* Disable the Elasticsearch ooutput and enable the Logstash output"
sed -i '139s/^/#/; 141s/^/#/' /etc/filebeat/filebeat.yml
sed -i '152s/^#//; 154s/^  #hosts:.*/  hosts: ["192.168.99.100:5044"]/' /etc/filebeat/filebeat.yml

echo "* Check the configuration"
filebeat test config

echo "* Enable the system module"
filebeat modules enable system

echo "* Adjust the main config file"
cat > temp_file <<EOF
- type: filestream
  enabled: true
  paths:
    - /tmp/app.log
EOF

{ head -n 56 /etc/filebeat/filebeat.yml; cat temp_file; tail -n +56 /etc/filebeat/filebeat.yml; } > new_file
mv new_file /etc/filebeat/filebeat.yml

echo "* Generate a few messages in the monitored log file"
for i in $(seq 1 10); do echo "$(date) -> test message #$i" >> /tmp/app.log; sleep 3; done

echo "* Install the beat teamplate in Elasticsearch"
filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["192.168.99.100:9200"]'

echo "* Start and enable filebeat.service"
systemctl daemon-reload
systemctl enable --now filebeat