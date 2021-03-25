require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module QiaojiangWeb
  class Application < Rails::Application

    config.to_prepare do
      Devise::SessionsController.layout 'admin_lte_2_login'
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
    config.assets.precompile += %w(swagger_ui.js swagger_ui.css swagger_ui_print.css swagger_ui_screen.css)
    # config.eager_load_namespaces << Grape
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'zh-CN', '*.yml').to_s]
    config.i18n.available_locales = [:en, 'zh-CN']
    config.i18n.default_locale = 'zh-CN'
    config.eager_load_paths += %W(#{Rails.root.join}/lib)
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end
