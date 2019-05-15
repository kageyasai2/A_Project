require 'sinatra'
require_relative 'base'

require './models/user.rb'

class User_controller < Base
  get '/' do
    erb :'user/confirm'
  end

  post '/confirm' do
    user = User.new({name:params[:name],email:params[:email],password:params[:password],password_confirmation:params[:password_confirmation]})
    if user.save
      erb :'user/login'
    else
      erb :'user/test'
    end
  end

  post '/user' do
    check_user = User.find_by(name: params[:name])
    #check_user is True and params[:password] = check_user.password
    unless check_user.blank?
      password_check = User.authenticate(params[:name],params[:password])
      if password_check
        redirect "/"
      else
        redirect "/login"
      end
    else
      redirect "/login"
    end
  end
end