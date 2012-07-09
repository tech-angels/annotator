module Annotator
  module InitialDescription

    # Initial descriptinos for paperclip attachments columns
    class Paperclip < Base

      def check
        if @model.respond_to?(:attachment_definitions) && @model.attachment_definitions
          @model.attachment_definitions.keys.each do |att|
            cols = ["#{att}_file_name", "#{att}_content_type", "#{att}_file_size", "#{att}_updated_at"]
            if cols.include? @column
              @attachment = att
              return true 
            end
          end
        end
        return false
      end

      def text
        "Paperclip for #{@attachment}"
      end

    end
  end
end
