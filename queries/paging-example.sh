#!/bin/sh

# Records count is in the header
curl -i -X GET http://localhost:8080/v3/facts --data-urlencode 'limit=5' --data-urlencode 'offset=2' --data-urlencode 'include-total=true' --data-urlencode 'query=["=", "certname", "puppetmaster.example.com"]'
