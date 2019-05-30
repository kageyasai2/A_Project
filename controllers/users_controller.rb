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
    if params[:password_confirmation] && user.save
      erb :'sessions/login'
    else
      set_error_message_of_signup(user.errors.messages)
      erb :'users/signup'
    end
  end

  private

  def set_error_message_of_signup(error_messages)
    if error_messages[:email].present?
      flash.now[:email] = error_messages[:email][0]
    end

    if error_messages[:password_confirmation].present?
      flash.now[:password_confirmation] = error_messages[:password_confirmation][0]
    end
  end
end
