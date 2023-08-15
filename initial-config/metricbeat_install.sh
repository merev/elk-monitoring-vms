#!/bin/bash

echo "* Download Metricbeat package"
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.9.0-amd64.deb

echo "* Install the software"
dpkg -i metricbeat-8.9.0-amd64.deb

echo "* Disable the Elasticsearch ooutput and enable the Logstash output"
sed -i '92s/^/#/; 94s/^/#/' /etc/metricbeat/metricbeat.yml
sed -i '105s/^#//; 107s/^  #hosts:.*/  hosts: ["192.168.99.100:5044"]/' /etc/metricbeat/metricbeat.yml

echo "* Check the configuration"
metricbeat test config

echo "* Install the beat teamplate in Elasticsearch"
metricbeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["192.168.99.100:9200"]'

echo "* Start and enable metricbeat.service"
systemctl daemon-reload
systemctl enable --now metricbeat