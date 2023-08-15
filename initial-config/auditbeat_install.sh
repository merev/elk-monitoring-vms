#!/bin/bash

echo "* Download Auditbeat package"
wget https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-8.9.0-amd64.deb

echo "* Install the software and save the output in a file"
dpkg -i auditbeat-8.9.0-amd64.deb

echo "* Disable the Elasticsearch ooutput and enable the Logstash output"
sed -i '147s/^/#/; 149s/^/#/' /etc/auditbeat/auditbeat.yml
sed -i '160s/^#//; 162s/^  #hosts:.*/  hosts: ["192.168.99.100:5044"]/' /etc/auditbeat/auditbeat.yml

echo "* Check the configuration"
auditbeat test config

echo "* Install the beat teamplate in Elasticsearch"
auditbeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["192.168.99.100:9200"]'

echo "* Start and enable auditbeat.service"
systemctl daemon-reload
systemctl enable --now auditbeat