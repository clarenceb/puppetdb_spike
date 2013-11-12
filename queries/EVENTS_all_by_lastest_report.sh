#!/bin/sh

curl -X GET http://localhost:8080/v3/events --data-urlencode 'query=["=", "latest-report?", "true"]' --data-urlencode 'order-by=[{"field": "timestamp", "order": "desc"}]'
