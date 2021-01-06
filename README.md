# ELIZA
A rulebased dialog plattform for human to software interaction

# Overview filesystem
## .
Root directory of the Eliza platform. Here you will find following files and directories:
### LICENSE
Eliza is distributed under the CC0 1.0 Universal CREATIVE COMMONS license
[a relative link](LICENSE)
##
Each directory represent a docker container with have one ore more apps. Each container service is specified in docker-compose.yml
## harry
An Alpine Docker image running the Eliza engine using the Mojolicious web server
## db
An Alpine Docker image running a Postgres Database for Eliza and Mojolicious minion database

# About docker-compose directive restart
All containers will be restarted automatic unless stopped manually