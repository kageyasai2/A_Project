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

SET_ENV_COM=
ifeq ($(OS),Windows_NT)
	SET_ENV_COM = SET APP_ENV=test;
else
	SET_ENV_COM = APP_ENV=test
endif

migrate:
	@echo '[Dev] Migrate ======================================================================='
	bundle exec rake db:migrate
	@echo '[Test] Migrate ======================================================================='
	$(SET_ENV_COM) bundle exec rake db:migrate
