require 'sinatra/base'

class Base < Sinatra::Base
  require_relative '../config/environments'
  configure do
    set :root, ROOT_DIR
  end

  before do
  end
end
