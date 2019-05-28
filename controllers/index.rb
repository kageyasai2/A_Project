require 'sinatra'
require_relative 'base'

class IndexController < Base
  get '/' do
    erb :index
  end

  get '/home' do
    if session[:user_id]
      @user_foods = UserFood.where(user_id: session[:user_id])
    end
    @user_foods ||= []

    erb :home
  end

  get '/terms_of_service' do
    erb :'terms_of_service'
  end
end
