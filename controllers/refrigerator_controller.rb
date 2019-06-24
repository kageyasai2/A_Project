require 'sinatra'
require_relative 'base'

class RefrigeratorController < Base
  before do
    if @current_user.blank?
      flash[:error] = '食材管理画面はログインしているユーザのみ使用可能です。'
      redirect '/auth/login'
    end
  end

  get '/' do
    erb :'refrigerator/index'
  end
end
