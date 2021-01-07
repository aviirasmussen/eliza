# ELIZA
A rulebased dialog plattform for human to software interaction

# Overview filesystem
## .
Root directory of the Eliza platform. Here you will find following files and directories:

### .env
Holds all environment variables for local scripts, docker-compose AND containers
### templates
templates is the directory home for robotics rulesets aka domains within the Eliza plattform. Each subdirectory under the templates directory equels to one domain under Eliza.
This directory is a mount under a Harry container. Every change under this directory will therefore be reflected in a live Harry container. Typical we will want to cahnge how a human to software rulset will be over time - without making a a redeploy. 
### deploy.sh
A shell script that tranfers changes from *src/* that *are* ready to be deployd and started in a harry container .
- Collects and uses varables from .env
- Transfers just the difference between src files and destinations files
#### ./data/templates
/data/templates is the directory home for bot rulesets aka domains for Eliza, each subdirectory under templates equals one domain with dialog plans. and holds  in a container.
- Directory gets mounted in a harry container and changes here *will* effect a running harry container


### src
Eliza Source tree. See [source readme](src/README.md)
### LICENSE
Eliza is distributed under the CC0 1.0 Universal [CREATIVE COMMONS license](LICENSE)
# Docker generic configuration for Eliza
 - All containers will be restarted automatically unless stopped manually
### docker-compose.yml
Holds service definitions for this plattform
#### Harry
An Alpine Docker image running the Eliza engine using the Mojolicious web server
#### Database
An Alpine Docker image running a Postgres Database for Eliza and the Mojolicious minion database


# Overview of Docker commands used for Eliza during develpment and production runs
## docker-compose config
Outputs the docker-compose.yml file with correctly mapped environment
## docker-compose up -d
Starts the Harry and Db containers detached.
## docker-compose down
Stops the containers
## docker exec -i -t harry /bin/bash
Opens an interactive bash shell inside a harry container
