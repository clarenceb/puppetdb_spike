#!/bin/sh

curl -X GET http://localhost:8080/v3/resources/User --data-urlencode query@specific-user-search.txt
