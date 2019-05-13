NAME=

.PHONY: help run test create_table migrate

help: Makefile
	@cat Makefile

run:
	bundle exec rackup config.ru

test:
	bundle exec rake spec


create_table:
	bundle exec rake db:create_migration NAME=$(NAME)

migrate:
	@echo '[Dev] Migrate ======================================================================='
	bundle exec rake db:migrate
	@echo '[Test] Migrate ======================================================================='
	APP_ENV=test bundle exec rake db:migrate
