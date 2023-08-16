#!/bin/bash

echo "* Download Logstash package"
wget https://artifacts.elastic.co/downloads/logstash/logstash-8.9.0-amd64.deb

echo "* Install the software"
dpkg -i logstash*.deb

echo "* Add beats configuration to logstash"
cp /shared/logstash/heartbeat /etc/logstash/conf.d/beats.conf

echo "* Start and enable logstash.service"
systemctl daemon-reload
systemctl enable --now logstash
