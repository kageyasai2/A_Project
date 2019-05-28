require 'sinatra'
require 'sinatra/base'
require_relative 'config/environments'

require 'active_record'
ActiveRecord::Base.configurations = YAML.load_file(File.join(ROOT_DIR, 'config/database.yml'))
ActiveRecord::Base.establish_connection(settings.environment)


Dir[CONTROLLERS_DIR + '/*.rb'].each do |controller|
  require controller
end

Dir[MODELS_DIR + '/*.rb'].each do |model|
  require model
end

class Main < Sinatra::Base
  ROUTES = {
    '/' => IndexController,
    '/auth' => SessionsController,
    '/signup' => UsersController,
    '/user_foods'   => UserFoodsController,
    '/discarded_foods' => DiscardedFoodsController,
    '/recipes' => RecipesController,
  }
end
