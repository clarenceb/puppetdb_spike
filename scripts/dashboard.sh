#!/bin/bash

echo "Running dashboard..."

if [ $EUID != 0 ]
then
   echo "Please run this script as root."
   exit 1
fi

source /root/.bash_profile
cd /vagrant/dashboard/webapp
nohup bundle exec dashing start &

echo "Open a browser to: http://localhost:3030"

echo "Done."
