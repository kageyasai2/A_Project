@echo '[Dev] Migrate ======================================================================='
SET APP_ENV=development
bundle exec rake db:migrate
@echo '[Test] Migrate ======================================================================='
SET APP_ENV=test
bundle exec rake db:migrate
