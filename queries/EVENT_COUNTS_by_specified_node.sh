#!/bin/sh

curl -X GET http://localhost:8080/v3/event-counts --data-urlencode 'query=["=", "certname", "puppetmaster.example.com"]' --data-urlencode 'summarize-by=certname'
