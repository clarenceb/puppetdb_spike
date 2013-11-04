#!/bin/sh

curl -X GET http://localhost:8080/v3/nodes/`hostname -f`/facts
