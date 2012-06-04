require 'annotator/initial_description/base'
Dir[File.dirname(__FILE__) + '/initial_description/*.rb'].each {|file| require file }

module Annotator
  module InitialDescription

    NO_DESCRIPTION_COLUMNS = %w{email name title body} 

    # Get initial description for given model & column
    def self.for(model, column)
      # Check if any module provides such description
      Base.providers.each do |klass|
        provider = klass.new model, column
        return provider.text if provider.check
      end
      # Some columns are just too obvious
      return "" if NO_DESCRIPTION_COLUMNS.include? column
      # Let user do the work
      return "TODO: document me"
    end

  end
end
