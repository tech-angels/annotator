module TestApp

  # No mattr_accessor before initialization ;(
  def self.path=(new_path)
    @path = new_path
  end

  def self.path
    @path
  end

  def self.prepare!
    self.path = File.expand_path("../../../tmp/dummy",  __FILE__)
    FileUtils.rm_rf path
    FileUtils.mkdir_p path
    FileUtils.cp_r File.expand_path("../../dummy//", __FILE__), File.expand_path(path+"/../")
    system("cd #{path} && bundle exec rake db:migrate > /dev/null")
  end
end
