require 'sinatra'
require_relative 'base'

class UsersController < Base
  get '/' do
    erb :'users/signup'
  end

  post '/' do
    @user = User.new({
      name: params[:name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
    })

    if params[:password_confirmation] && @user.save
      redirect :'auth/login'
    else
      erb :'users/signup'
    end
  end
end
