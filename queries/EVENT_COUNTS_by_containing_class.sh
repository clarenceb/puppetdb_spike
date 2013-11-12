#!/bin/sh

curl -X GET http://localhost:8080/v3/event-counts --data-urlencode 'query=["=", "containing-class", "Puppetdb::Master::Storeconfigs"]' --data-urlencode 'summarize-by=containing-class'
