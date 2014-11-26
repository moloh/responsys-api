require "bundler/setup"
Bundler.setup

require "responsys_api.rb"
require "vcr"
require "yaml"

if File.exist?("#{File.dirname(__FILE__)}/api_credentials.yml")
  CREDENTIALS = YAML.load_file("#{File.dirname(__FILE__)}/api_credentials.yml")
else
  CREDENTIALS = YAML.load_file("#{File.dirname(__FILE__)}/api_credentials.sample.yml")
end

DATA = YAML.load_file("#{File.dirname(__FILE__)}/test_data.yml")
IGNORE_LOGIN_REQUEST = true
IGNORE_LOGOUT_REQUEST = true

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock
  c.filter_sensitive_data('your_responsys_username') { CREDENTIALS["username"] }
  c.filter_sensitive_data('your_responsys_password') { CREDENTIALS["password"] }
end

Responsys.configure do |config|
  config.settings = {
    username: CREDENTIALS["username"],
    password: CREDENTIALS["password"],
    wsdl: CREDENTIALS["wsdl"],
    debug: false
  }
end