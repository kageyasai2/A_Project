require 'sinatra'
require_relative 'base'

class SessionsController < Base
  get '/logout' do
    session[:user_id] = nil

    redirect '/'
  end
end

