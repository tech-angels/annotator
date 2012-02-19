require 'annotator/railtie'

module Annotator
  def self.run
    models = Dir.glob("#{Rails.root}/app/models/*.rb").map do |filename|
      klass = filename.split('/').last.split(/\.rb$/).first.camelize.constantize
      [filename, klass]
    end.sort_by {|x| x.last.to_s}

    i = 0
    models.each do |filename, model|
    begin
      file = File.read(filename)
      lines = file.split("\n")
      out = ''
      ia = false # inside attributes block
      after_block = false
      changed = false
      skip_file = false
      attrs_arr = []
      lines.each do |line|
        break if skip_file
        out << "#{line}\n" && next if after_block

        if ia && !line.match(/^# \*/) && !line.match(/^#   \S/)
          out << stringify_attrs_arr(update_attrs_arr(attrs_arr, model))
          ia = false
          changed = true
        end

        # check if we are still in the comments part of the file
        unless line.strip.empty? || line.match(/^\s*#/)
          after_block = true
          unless changed
            out << "# Attributes:\n"
            out << stringify_attrs_arr(update_attrs_arr(attrs_arr, model))
          end
        end

        if ia
          if line.match(/^# \*/)
            m = line.match(/^# \* (\w+) \[(.*?)\]( \- )?(.*)/)
            if m
              attrs_arr << [m[1], m[2], m[4]].map(&:strip)
            else
              puts "!! Unrecognized line format on attributes list in #{model}:"
              puts line
            end
          else
            attrs_arr[-1][2] << " #{line[4..-1]}"
          end
        else
          out << "#{line}\n"
        end

        ia = true if line.match(/^# Attributes:/i)
        skip_file = true if line.match(/^# Attributes\(nodoc\):/i)
      end

      File.open(filename,'w') { |f| f.write(out) } if out.strip != file.strip && !skip_file

    rescue Exception => e
      puts "FAILURE while trying to update model #{model}:\n  #{e.to_str}"
    end
    end


  end

  protected

  def self.update_attrs_arr(arr, model)
    arr = arr.dup
    model.columns.each do |column|
      attrs_str = column_attrs(column)
      if row = arr.find {|x| x[0] == column.name}
        if row[1] != attrs_str
          puts "  M #{model}##{column.name} [#{row[1]} -> #{attrs_str}]"
          row[1] = attrs_str
        end
      else
        puts "  A #{model}##{column.name} [#{attrs_str}]"
        desc = "TODO: document me"
        desc = "primary key" if column.name == 'id'
        desc = "creation time" if column.name == 'created_at'
        desc = "last update time" if column.name == 'updated_at'
        arr << [column.name, attrs_str, desc]
      end
    end

    # find columns that no more exist in db
    orphans = arr.map(&:first) - model.columns.map(&:name)
    unless orphans.empty?
      orphans.each do |orphan|
        puts "  D #{model}#{orphan}"
        arr = arr.select {|x| x[0] != orphan}
      end
    end
    arr
  end

  def self.column_attrs(c)
    ret = c.type.to_s
    ret << ", primary" if c.primary
    ret << ", default=#{c.default}" if c.default
    ret << ", not null" unless c.null
    ret << ", limit=#{c.limit}" if c.limit && (c.limit != 255 && c.type != :string)
    ret
  end

  def self.stringify_attrs_arr(arr)
    ret = ''
    arr.sort_by{|x| x[0] == 'id' ? '_' : x[0]}.each do |name, attrs, desc|
      # split into lines that don't exceed 80 chars
      desc = " - #{desc}" unless desc.empty?
      line = "# * #{name} [#{attrs}]#{desc}"
      lt = wrap_text(line, opts[:max_chars_per_line]-3).split("\n")
      line = ([lt[0]] + lt[1..-1].map{|x| "#   #{x}"}).join("\n")
      ret << "#{line}\n"
    end
    ret
  end

  def self.wrap_text(txt, col)
    txt.gsub(/(.{1,#{col}})( +|$)\n?|(.{#{col}})/,"\\1\\3\n")
  end

  def self.opts
    {
      :max_chars_per_line => 120
    }
  end


end

