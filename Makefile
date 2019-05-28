NAME=

.PHONY: help run test create_table migrate

help: Makefile
	@cat Makefile

run:
	bundle exec rackup config.ru

test:
	bundle exec rake spec

test/diff:
	git status -s | awk '/_spec/ {print $$2}' | xargs bundle exec rspec

create_table:
	bundle exec rake db:create_migration NAME=$(NAME)


migrate:
ifeq ($(OS), Windows_NT)
	make win/migrate
else
	@echo '[Dev] Migrate ======================================================================='
	bundle exec rake db:migrate
	@echo '[Test] Migrate ======================================================================='
	APP_ENV=test bundle exec rake db:migrate
endif

win/migrate:
ifeq ($(OS), Windows_NT)
	call shell_helpers/win_migrate.bat
else
	echo 'Your pc is not windows os'
endif


dry/lint:
	bundle exec rubocop -D -E -S -P

lint:
	bundle exec rubocop -a
