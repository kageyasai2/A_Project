require 'sinatra'
require_relative 'base'

require './models/user.rb'

class UserController < Base
  get '/' do
    erb :'user/signup'
  end

  post '/' do
    user = User.new({
      name: params[:name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    })
    if user.save
      erb :'user/login'
    else
      erb :'user/signup'
    end
  end
end
