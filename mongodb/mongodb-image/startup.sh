#!/bin/bash
echo "startup script"
mongod --fork --logpath /var/log/mongodb.log
ps -fe|grep mongo
mongo < /opt/adduser.js
mongod --shutdown
ps -fe|grep mongo
mongod --auth --fork --logpath /var/log/mongodb.log
ps -fe|grep mongo
sleep 360d
