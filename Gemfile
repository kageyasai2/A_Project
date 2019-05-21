# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'rake'
gem 'sinatra'
gem 'bcrypt', git: 'https://github.com/codahale/bcrypt-ruby.git'
gem 'nokogiri'

gem 'sqlite3'
gem 'activerecord'
gem 'sinatra-activerecord'

group :test do
  gem 'rspec'
  gem 'rack-test'
end
