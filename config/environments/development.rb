Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # config.relative_url_root = '/work-orders'

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.action_mailer.delivery_method = :sendmail

  config.study_url = 'http://localhost:3300/api/v1'
  config.study_url_default_proxy = 'http://localhost:3300'

  config.set_url = 'http://localhost:3000/api/v1'
  config.set_url_default_proxy = 'http://localhost:3000'

  config.material_url = 'http://localhost:5000'

  config.stamp_url = 'http://localhost:7000/api/v1'

  config.jwt_secret_key = 'development'

  config.events = {
    enabled: false,
    broker_host: 'localhost',
    broker_port: '5672',
    broker_vhost: '/',
    broker_username: 'guest',
    broker_password: 'guest',
    exchange_name: 'aker.events',
    warehouse_queue_name: 'aker.events.warehouse',
    notification_queue_name: 'aker.events.notifications',
    catalogue_queue_name: 'aker.events.catalogue'
  }

  config.work_order_completion_json = 'work_order_completion.json'

  config.billing_facade_url = 'http://localhost:3601'

  config.fake_ldap = true

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # SSO
  config.default_jwt_user = { email: ENV.fetch('USER', 'user') + '@sanger.ac.uk',
                              groups: ['world'] }

  config.auth_service_url = 'http://localhost:9010'
  config.login_url = config.auth_service_url + '/login'
  config.logout_url = config.auth_service_url + '/logout'

  config.urls = { submission: '',
                  permissions: '',
                  sets: '',
                  projects: '',
                  work_orders: '' }
end
