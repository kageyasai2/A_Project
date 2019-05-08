require 'sinatra'

ROOT_DIR = File.expand_path('..', __dir__)
CONTROLLERS_DIR = File.expand_path('../controllers', __dir__)

configure do
  set :root, ROOT_DIR
end
