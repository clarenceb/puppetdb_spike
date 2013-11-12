#!/bin/sh

# See: http://docs.puppetlabs.com/puppetdb/1.5/api/query/v3/events.html for more details.

# Selected the 2nd latest report
REPORT_HASH=`curl -s -X GET http://localhost:8080/v3/reports --data-urlencode 'query=["=", "certname", "puppetmaster.example.com"]' --data-urlencode 'limit=1' | grep hash | sed -E 's/"hash" : "(.*)",/\1/' | tr -d ' \t\n\r\f'`

if [ -z "${REPORT_HASH}" ]
then
   echo "You need to generate a few more reports first.  Hint: \`run puppet agent -t\`"
   exit 1
fi

curl -X GET http://localhost:8080/v3/events --data-urlencode "query=[\"=\", \"report\", \"${REPORT_HASH}\"]" --data-urlencode 'order-by=[{"field": "timestamp", "order": "desc"}]'
