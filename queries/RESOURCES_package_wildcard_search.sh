#!/bin/sh

curl -X GET http://localhost:8080/v3/resources/Package --data-urlencode query@package-wildcard-search.txt
