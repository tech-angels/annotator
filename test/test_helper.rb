require 'fileutils'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

$test_app = test_app_dir = File.expand_path("../../tmp/dummy",  __FILE__)
FileUtils.rm_rf test_app_dir
FileUtils.mkdir_p test_app_dir
FileUtils.cp_r File.expand_path("../dummy//", __FILE__), File.expand_path(test_app_dir+"/../")
system("cd #{$test_app} && bundle exec rake db:migrate > /dev/null")
 

require File.expand_path("#{test_app_dir}/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
