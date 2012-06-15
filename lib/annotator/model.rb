module Annotator

  # Represents a single model file and associated class
  class Model

    def initialize(filename, base_path)
      @filename = filename
      @base_path = base_path
      @blocks = Hash.new {[]}
    end

    # Model class
    def klass
      begin 
        @filename.split(@base_path).last.split(/\.rb$/).first.camelize.constantize rescue nil
      rescue Exception
        nil
      end
    end

    # Split file into 3 blocks: before attributes, attributes block, and after
    # If there's no attributes block, content will be in :after part (for easier insertion)
    def parse
      @file = File.read(@filename).strip
      current_block = :before
      return @nodoc = true if @file.match(/^# Attributes\(nodoc\):$/i)
      @file.split("\n").each do |line|
        if line.match(/^#{Regexp.escape Attributes::HEADER} *$/)
          current_block = :attributes
          next
        end
        current_block = :after if current_block == :attributes && !line.match(Attributes::R_ATTRIBUTE_LINE)
        @blocks[current_block] += [line]
      end


      # If there is no after block, it means there are no attributes block yet.
      # Let's try to find some good place to insert them.
      if @blocks[:after].empty?
        @blocks[:before].each_with_index do |line,i|
          # We want to insert them after requires or any comment block at the beginning of the file
          unless line.match(/^require/) || line.match(/^#/)
            @blocks[:after] = @blocks[:before][i..-1]
            @blocks[:before] = (i == 0) ? [] : @blocks[:before][0..(i-1)] + [''] # add one additional separation line to make it cleaner
            break
          end
        end
      end

    end

    # If this file does not have associated AR class it should be skipped
    def skipped?
      !klass || !klass.ancestors.include?(ActiveRecord::Base) || @nodoc
    end

    # Save changes to file if there were any
    def update_file
      output = (@blocks[:before] + @blocks[:attributes] + @blocks[:after]).join("\n").strip + "\n"
      File.open(@filename,'w') { |f| f.write(output) } if output != @file
    end

    # Update file with new database information
    def update!
      parse
      return true if skipped?
      attributes = Attributes.new klass, @blocks[:attributes]
      attributes.update!
      @blocks[:attributes] = attributes.lines
      update_file
    end
  end
end


