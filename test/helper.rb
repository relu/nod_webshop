require 'nod_webshop'
require 'minitest/autorun'
require 'minitest/spec'
require 'vcr'
require 'webmock/minitest'

VCR.configure do |c|
  c.cassette_library_dir = "test/tmp/fixtures/vcr"
  c.hook_into :webmock
  c.ignore_localhost = true
  c.default_cassette_options = { :record => :all }
end
