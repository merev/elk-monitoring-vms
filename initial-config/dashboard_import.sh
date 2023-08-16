#!/bin/bash

echo "* Import Dashboard from JSON file"
curl -X POST "192.168.99.100:5601/api/kibana/dashboards/import" -H "kbn-xsrf: true" -H "Content-Type: application/json" -d @/shared/kibana/infra_monitoring.json