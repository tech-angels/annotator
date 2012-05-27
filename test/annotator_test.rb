require 'test_helper'
require 'tempfile'

class AnnotatorTest < ActiveSupport::TestCase
  def setup
    @output = execute("cd #{$test_app} && rake annotate")
  end

  test "annotating foo" do
    assert_equal File.read(asset_file 'foo_annotated.rb' ), File.read(app_file 'foo.rb' )
  end

  test "leaving existing comments" do
    FileUtils.cp asset_file('foo_annotated_with_comments.rb'), app_file('foo.rb')
    assert system("cd #{$test_app} && rake annotate")
    assert_equal File.read(asset_file 'foo_annotated_with_comments.rb' ), File.read(app_file 'foo.rb' )
  end

  test "updating column type" do
    FileUtils.cp asset_file('foo_annotated_bad_column.rb'), app_file('foo.rb')
    output = execute("cd #{$test_app} && rake annotate")
    assert_equal File.read(asset_file 'foo_annotated_column_fixed.rb' ), File.read(app_file 'foo.rb' )
    assert output.include?('M Foo#title [octopus -> string]')
    assert output.include?('M Foo#created_at [foobar -> datetime, not null]')
  end

  test "skipping when nodoc is preesnt" do
    FileUtils.cp asset_file('foo_annotated_bad_column_nodoc.rb'), app_file('foo.rb')
    execute("cd #{$test_app} && rake annotate")
    assert_equal File.read(asset_file 'foo_annotated_bad_column_nodoc.rb' ), File.read(app_file 'foo.rb' )
  end

  test "annotating devise columns" do
    assert_equal File.read(asset_file 'user_annotated.rb' ), File.read(app_file 'user.rb' )
  end 

  def asset_file(name)
    File.join(File.expand_path("../assets/",  __FILE__), name)
  end

  def app_file(name)
    File.join($test_app,'app','models',name)
  end

  # Check exit code while grabbing output
  def execute(command)
    tmp = Tempfile.new "output"
    assert system("#{command} > #{tmp.path}")
    output = tmp.read
    tmp.unlink
    output
  end
end
