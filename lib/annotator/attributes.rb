module Annotator

  # Attributes within given model file
  class Attributes
    R_ATTRIBUTE = /^# \* (\w+) \[(.*?)\]( \- )?(.*)$/
    R_ATTRIBUTE_NEXT_LINE = /^#   (.*?)$/
    R_ATTRIBUTE_LINE = /(#{R_ATTRIBUTE})|(#{R_ATTRIBUTE_NEXT_LINE})/
    HEADER = "# Attributes:"
    MAX_CHARS_PER_LINE = 120

    def initialize(model, lines)
      @model = model
      @lines = lines
      @attrs = []
      @changes = []
      parse
    end

    # Convert attributes array back to attributes lines representation to be put into file
    def lines
      ret = [Attributes::HEADER]
      # Sort by name, but id goes first
      @attrs.sort_by{|x| x[:name] == 'id' ? '_' : x[:name]}.each do |row|
        line = "# * #{row[:name]} [#{row[:type]}]#{row[:desc].to_s.empty? ? "" : " - #{row[:desc]}"}"
        # split into lines that don't exceed 80 chars
        lt = wrap_text(line, MAX_CHARS_PER_LINE-3).split("\n")
        line = ([lt[0]] + lt[1..-1].map{|x| "#   #{x}"}).join("\n")
        ret << line
      end
      ret
    end

    # Update attribudes array to the current database state
    def update!
      @model.columns.each do |column|
        if row = @attrs.find {|x| x[:name] == column.name}
          if row[:type] != type_str(column)
            puts "  M #{@model}##{column.name} [#{row[:type]} -> #{type_str(column)}]"
            row[:type] = type_str(column)
          elsif row[:desc] == InitialDescription::DEFAULT_DESCRIPTION
            new_desc = InitialDescription.for(@model, column.name)
            if row[:desc] != new_desc
              puts "  M #{@model}##{column.name} description updated"
              row[:desc] = new_desc
            end
          end
        else
          puts "  A #{@model}##{column.name} [#{type_str(column)}]"
          @attrs << {
            :name => column.name,
            :type => type_str(column),
            :desc => InitialDescription.for(@model, column.name)
          }
        end
      end

      # find columns that no more exist in db
      orphans = @attrs.map{|x| x[:name]} - @model.columns.map(&:name)
      unless orphans.empty?
        orphans.each do |orphan|
          puts "  D #{@model}##{orphan}"
          @attrs = @attrs.select {|x| x[:name] != orphan}
        end
      end

      @attrs
    end

    protected

    # Convert attributes lines into meaniningful array
    def parse
      @lines.each do |line|
        if m = line.match(R_ATTRIBUTE)
          @attrs << {:name => m[1].strip, :type => m[2].strip, :desc => m[4].strip}
        elsif m = line.match(R_ATTRIBUTE_NEXT_LINE)
          @attrs[-1][:desc] += " #{m[1].strip}"
        end
      end
    end

    # default value could be a multiple lines string, which would ruin annotations,
    # so we truncate it and display inspect of that string
    def truncate_default(str)
      return str unless str.kind_of? String
      str.sub!(/^'(.*)'$/m,'\1')
      str = "#{str[0..10]}..." if str.size > 10
      str.inspect
    end

    # Human readable description of given column type
    def type_str(c)
      ret = c.type.to_s
      ret << ", primary" if c.primary
      ret << ", default=#{truncate_default(c.default)}" if c.default
      ret << ", not null" unless c.null
      ret << ", limit=#{c.limit}" if c.limit && (c.limit != 255 && c.type != :string)
      ret
    end

    # Wraps text nicely, not breaking in the middle of the word
    def wrap_text(txt, col)
      txt.gsub(/(.{1,#{col}})( +|$)\n?|(.{#{col}})/,"\\1\\3\n")
    end

  end
end
