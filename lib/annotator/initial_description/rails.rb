module Annotator
  module InitialDescription

    # Initial descriptions for rails specific columns
    class Rails < Base
      def check
        columns.keys.include? @column.to_sym
      end

      def columns
        {
          :id => "primary key", # TODO check if it actually is a primary key, find primary keys with other names
          :created_at => "creation time",
          :updated_at => "last update time" 
        }
      end

      def text
        columns[@column.to_sym]
      end
    end
  end
end
