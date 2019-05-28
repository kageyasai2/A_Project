require 'sinatra'
require_relative 'base'

require './models/user.rb'

class UsersController < Base
  get '/' do
    erb :'users/signup'
  end

  post '/' do
    user = User.new({
      name: params[:name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
    })

    if user.save
      erb :'sessions/login'
    else
      erb :'users/signup'
    end
  end
end
