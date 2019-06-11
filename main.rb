require 'sinatra'
require 'sinatra/base'
require_relative 'config/environments'
require 'active_record'
require 'i18n'
require 'i18n/backend/fallbacks'

configure do
  ActiveRecord::Base.configurations = YAML.load_file(File.join(ROOT_DIR, 'config/database.yml'))
  ActiveRecord::Base.establish_connection(settings.environment)

  I18n.load_path = Dir[File.join(settings.root, 'config/locales', '*.yml')]
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.enforce_available_locales = false
  I18n.default_locale = :ja
end

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
    '/user_foods' => UserFoodsController,
    '/discarded_foods' => DiscardedFoodsController,
    '/recipes' => RecipesController,
  }.freeze
end
