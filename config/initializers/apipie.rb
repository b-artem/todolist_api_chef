Apipie.configure do |config|
  config.app_name                = "TodolistApi"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.translate               = false
  config.default_locale          = 'en'
  config.app_info = 'Simple TODO List API (RG Courses task). The idea of the '\
        'project is a simple tool for productivity improvement. It let the user'\
        ' an ability to easy manage and control his own projects and tasks.'
end
