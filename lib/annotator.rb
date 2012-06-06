require 'annotator/railtie'
require 'annotator/model'
require 'annotator/attributes'
require 'annotator/initial_description'

module Annotator

  def self.run(models_path = nil)
    models_path ||= defined?(Rails) ? "#{Rails.root}/app/models" : "."
    update_models(models_path)
  end

  def self.update_models(models_path)
    path = "#{models_path}/**/*.rb"
    Dir.glob(path).sort.map do |filename|
      Model.new(filename, models_path).update!
    end
  end

end

