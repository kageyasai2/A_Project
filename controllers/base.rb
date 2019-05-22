require 'sinatra/base'
require 'rack/flash'

class Base < Sinatra::Base
  require_relative '../config/environments'
  configure do
    set :root, ROOT_DIR
    enable :sessions
    use Rack::Flash
  end

  before do
    @app_name = APP_NAME
    @title = 'タイトル'

    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end
end
