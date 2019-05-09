require 'sinatra/base'

class Base < Sinatra::Base
  require_relative '../config/environments'
  configure do
    set :root, ROOT_DIR
  end

  before do
    @app_name = APP_NAME
    @title = 'タイトル'
  end
end
