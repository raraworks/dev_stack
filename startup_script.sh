#!/bin/bash
#Startup multiple processes
service cron start
service php8.0-fpm start
nginx -g "daemon off;"
