module Annotator
  module InitialDescription

    # Base class from which all other description providers inherit
    class Base
      def initialize(model, column)
        @model = model
        @column = column
      end

      def self.inherited(klass)
        @providers ||= []
        @providers << klass
      end

      def self.providers
        @providers
      end
    end
  end
end
