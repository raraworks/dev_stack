#!/bin/bash
#Startup multiple processes
service cron start
service php7.3-fpm start
nginx -g "daemon off;"
