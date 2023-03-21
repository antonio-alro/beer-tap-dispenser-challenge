.PHONY: test

build:
	docker compose build

up: .migrate-dev
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f

test: .migrate-test
	docker compose run -e RAILS_ENV=test --rm ruby-skeleton-api sh -c "bundle exec rake test"

.migrate-test:
	docker compose run -e RAILS_ENV=test --rm ruby-skeleton-api sh -c "bundle exec rails db:create && rails db:migrate"

.migrate-dev:
	docker compose run -e RAILS_ENV=development --rm ruby-skeleton-api sh -c "bundle exec rails db:create && rails db:migrate"
