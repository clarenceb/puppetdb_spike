#!/bin/sh

curl -X GET http://localhost:8080/v3/events --data-urlencode 'query=["=", "status", "success"]' --data-urlencode 'order-by=[{"field": "timestamp", "order": "desc"}]' --data-urlencode 'limit=20'
