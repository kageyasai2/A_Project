# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'addressable', '~> 2.8'
gem 'bcrypt', git: 'https://github.com/codahale/bcrypt-ruby.git'
gem 'gon-sinatra'
gem 'i18n'
gem 'nokogiri'
gem 'rack-flash3'
gem 'rake'
gem 'sinatra'

gem 'activerecord'
gem 'sinatra-activerecord'
gem 'sqlite3'

group :development do
  gem 'onkcop', require: false
  gem 'pre-commit', require: false
end

group :test do
  gem 'rack-test'
  gem 'rspec'
end
