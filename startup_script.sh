#!/bin/bash
#Startup multiple processes
service php7.4-fpm start
nginx -g "daemon off;"
