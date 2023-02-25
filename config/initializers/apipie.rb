Apipie.configure do |config|
  config.app_name                = 'InsatiableBackend'
  config.api_base_url            = '/v1'
  config.doc_base_url            = '/apipie'
  # where is your API defined?
  config.api_controllers_matcher = Rails.root.join('app/controllers/**/*.rb')
end
