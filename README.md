# eliza
A rulebased dialog plattform for human interaction

# Overview files
Each directory represent a Docker container with one ore more apps. Each container is defined in the root file docker-compose.yml
## harry
An Alpine Docker image running the Eliza engine
## db
An Alpine Docker image running a Postgres Database for Eliza and Mojolicious

# About docker-compose directive restart
All containers will be restarted automatic unless stopped manually