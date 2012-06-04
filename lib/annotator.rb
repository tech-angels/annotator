require 'annotator/railtie'
require 'annotator/model'
require 'annotator/attributes'
require 'annotator/initial_description'

module Annotator

  def self.run
    Dir.glob("#{Rails.root}/app/models/*.rb").sort.map do |filename|
      Model.new(filename).update!
    end
  end

end

