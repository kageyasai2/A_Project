require 'sinatra'
require_relative 'base'

require './models/user.rb'

class UsersController < Base
  get '/' do
    erb :'users/signup'
  end

  post '/' do
    confirm_password_equals_password_confirmation
    confirm_email_exists_into_user_table

    if flash[:email_error].present? || flash[:password_error].present?
      return erb :'users/signup'
    end

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

  private

  def confirm_password_equals_password_confirmation
    if params[:password] != params[:password_confirmation]
      flash.now[:password_error] = "入力されたパスワードと再入力のパスワードが一致しません"
    end
  end

  def confirm_email_exists_into_user_table
    email = User.exists_email_into_user_table(params[:email])
    if email
      flash.now[:email_error] = "メールアドレス #{params[:email]}は既に使われています"
    end
  end
end
