#!/bin/sh

echo "Running puppetboard..."

if [ $EUID != 0 ]
then
   echo "Please run this script as root."
   exit 1
fi

cd /home/vagrant/puppetboard

# Start the web app in the background
nohup python dev.py &

echo "Open a browser to: http://localhost:5000"

echo "Done."
