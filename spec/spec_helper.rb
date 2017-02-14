if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dao/gateway/active_resource'
require 'rspec/its'
require 'pry'
require 'dao/entity'
require 'support/organization'
