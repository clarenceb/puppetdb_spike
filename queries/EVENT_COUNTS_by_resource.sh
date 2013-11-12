#!/bin/sh

curl -X GET http://localhost:8080/v3/event-counts --data-urlencode 'query=["=", "resource-type", "Ini_setting"]' --data-urlencode 'summarize-by=resource'
