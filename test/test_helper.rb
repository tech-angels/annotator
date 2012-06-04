require 'fileutils'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

TestApp.prepare!

require File.expand_path("#{TestApp.path}/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

