<img align="left"  width="150" height="150" src=".github/rviewer_logo--dark.png" />

## Rviewer skeleton: Ruby, Ruby on Rails, PostgreSQL

[![Twitter](https://img.shields.io/badge/rviewer__-%231DA1F2.svg?style=for-the-badge&logo=Twitter&logoColor=white)](https://twitter.com/Rviewer_/)

[![Rviewer Discord](https://badgen.net/discord/members/VVN4ur8FaQ)](https://discord.gg/VVN4ur8FaQ)

<br/>

This repository is a Ruby skeleton with Rails & PostgreSQL designed for quickly getting started developing an API.
Check the [Getting Started](#getting-started) for full details.

## Technologies

* [Ruby](https://www.ruby-lang.org/en/)
* [Ruby on Rails](https://rubyonrails.org/)
* [PostgreSQL](https://www.postgresql.org/)
* [MiniTest](https://github.com/minitest/minitest)
* [Docker](https://www.docker.com/)
* [Make](https://www.gnu.org/software/make/manual/make.html)

## Getting Started

Within the [Makefile](Makefile) you can handle the entire flow to get everything up & running:

1. Install `make` on your computer, if you do not already have it.
2. Build the application: `make build`
3. Start the application: `make up`
4. Run the application tests: `make test`

As you could see on the [Makefile](Makefile) script and the [Docker-Compose File](docker-compose.yml), the whole API
is containerized with Docker and the API is using the internal DNS to connect with the PostgreSQL instance.

Go to [http://0.0.0.0:3000/api/v1/ping](http://0.0.0.0:3000/api/v1/ping) to see that everything is up & running!

## Overview
This is a standard Rails application, so your typical MVC standards apply.
