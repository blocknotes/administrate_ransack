include extra/.env

help:
	@echo -e "${COMPOSE_PROJECT_NAME} - Main project commands:\n\
		make up   	# starts the dev services (optional env vars: RUBY / RAILS / RANSACK / ADMINISTRATE)\n\
		make specs	# run the tests (after up)\n\
		make lint 	# run the linters (after up)\n\
		make server	# run the server (after up)\n\
		make shell	# open a shell (after up)\n\
		make down 	# cleanup (after up)\n\
	Example: RUBY=3.2 RAILS=7.1 RANSACK=4.2.0 ADMINISTRATE=0.18.0 make up"

# System commands

build:
	@docker compose -f extra/docker-compose.yml build

bundle_install:
	@rm -f Gemfile.lock
	@docker compose -f extra/docker-compose.yml run --rm app bundle install

db_reset:
	@rm -f spec/dummy/db/*.sqlite3
	@docker compose -f extra/docker-compose.yml run --rm app bin/rails db:create db:migrate db:test:prepare

up: build bundle_install db_reset
	@docker compose -f extra/docker-compose.yml up

shell:
	@docker compose -f extra/docker-compose.yml exec app bash

down:
	@docker compose -f extra/docker-compose.yml down --rmi local --remove-orphans

# App commands

seed:
	@docker compose -f extra/docker-compose.yml exec app bin/rails db:seed

console: seed
	@docker compose -f extra/docker-compose.yml exec app bin/rails console

lint:
	@docker compose -f extra/docker-compose.yml exec app bin/rubocop

server: seed
	@rm -f spec/dummy/tmp/pids/server.pid
	@docker compose -f extra/docker-compose.yml exec app bin/rails server -b 0.0.0.0 -p ${SERVER_PORT}

specs:
	@docker compose -f extra/docker-compose.yml exec app bin/rspec
