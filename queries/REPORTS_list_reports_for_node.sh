#!/bin/sh

curl -X GET http://localhost:8080/v3/reports --data-urlencode 'query=["=", "certname", "puppetmaster.example.com"]'

