echo '[Dev] Migrate ======================================================================='
set APP_ENV=development
cmd.exe /C bundle exec rake db:migrate
echo '[Test] Migrate ======================================================================='
set APP_ENV=test
cmd.exe /C bundle exec rake db:migrate
