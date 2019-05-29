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
      setting_user_error_messages(user.errors.messages)
      erb :'users/signup'
    end
  end

  private

  def setting_user_error_messages(error_messages)
    if error_messages[:email].present?
      flash.now[:email_error] = error_messages[:email][0]
    end

    if error_messages[:password_confirmation].present?
      flash.now[:password_error] = error_messages[:password_confirmation][0]
    end
  end
end
