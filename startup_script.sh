#!/bin/bash
#Startup multiple processes
service cron start
service php8.1-fpm start
nginx -g "daemon off;"
