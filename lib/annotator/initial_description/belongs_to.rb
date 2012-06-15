module Annotator
  module InitialDescription

    # Initial descriptions for columns associated with belongs_to
    class BelongsTo < Base

      def check
        # check if there is belongs to association where this column is a foreign key
        @model.reflect_on_all_associations.each do |reflection|
          if (reflection.options[:foreign_key] || reflection.send(:derive_foreign_key)) == @column && reflection.macro == :belongs_to
            @reflection = reflection
            return true
          end
        end

        # Polymorphic association type column
        if @column.ends_with? '_type'
          return true if @reflection = @model.reflect_on_association(@column.match(/(.*?)_type$/)[1].to_sym) 
        end

        return false
      end

      def text
        "belongs to :#{@reflection.name}#{@reflection.options[:polymorphic] ? ' (polymorphic)' : ''}"
      end
    end
  end
end
