require 'sinatra'
require_relative 'base'

require './models/user.rb'

class UsersController < Base
  get '/' do
    flash[:errors] = {}
    erb :'users/signup'
  end

  post '/' do
    user = User.new({
      name: params[:name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
    })
    flash[:errors] = {}
    if params[:password_confirmation] && user.save
      p user.errors.messages[:email]
      p flash[:errors][:email]
      erb :'sessions/login'
    else
      flash[:errors] = user.errors.messages
      p user.errors.messages
      if flash[:errors][:email].present?
        p flash[:errors][:email]
      end
      erb :'users/signup'
    end
  end

end
