# WordPress Docker Dev Environment

## Prerequisites

-   If using private repos your .ssh key needs to be added to your [GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

## Development Setup

-   `git clone git@github.com:username/repoName.git`
-   `cd repoName`
-   `bash .config/bash/setup.sh`

## VSCode Setup

-   After install, open the root folder in VS code and install any recommended extensions.

## Running the evironment

-   From the root folder (repoName) run `docker-compose up`
-   Alternatively, you can run docker in the background by using `docker-compose up -d`

## WordPress

-   WordPress Homepage: `https://localhost`
-   Admin: `https://localhost/wp-admin`
-   User: `admin`
-   Password `admin`

## Using WP-CLI

-   `docker-compose exec php bash`
-   `docker-compose exec php wp plugin list`

## Viewing logs

-   If you bring docker in the foreground (not using -d), it will display logs for all running services
-   If you bring docker up int the background, from the root folder (docker-events) you can run - `docker-compose logs service -f`
-   e.g. `docker-compose logs php -f`
-   e.g. `docker-compose logs mysql -f`

## Dump Database

-   While docker is running, from the root folder (docker-events) run `docker-compose exec mysql mysqldump --set-gtid-purged=OFF --all-databases > ~/Desktop/db.sql`

## Mailhog

-   When running mail will be available at `http://localhost:8025`
