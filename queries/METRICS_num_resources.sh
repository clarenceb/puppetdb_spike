#!/bin/sh

curl -X GET 'http://localhost:8080/v3/metrics/mbean/com.puppetlabs.puppetdb.query.population%3Atype%3Ddefault%2Cname%3Dnum-resources'

