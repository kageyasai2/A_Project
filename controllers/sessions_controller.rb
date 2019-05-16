require 'sinatra'
require_relative 'base'

class SessionsController < Base
  get '/login' do
    erb :'sessions/login'
  end

  get '/logout' do
    session[:user_id] = nil

    redirect '/'
  end
end

