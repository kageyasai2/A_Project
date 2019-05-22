require 'sinatra'
require_relative 'base'

class SessionsController < Base
  get '/login' do
    erb :'sessions/login'
  end

  post '/login' do
    if !params[:email] || !params[:password]
      erb :'sessions/login' and return
    end

    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/'
    else
      @email = params[:email]
      @password = params[:password]

      erb :'sessions/login'
    end
  end

  get '/logout' do
    session[:user_id] = nil
    @current_user = nil

    redirect '/'
  end
end

