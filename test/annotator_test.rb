require 'test_helper'

class AnnotatorTest < ActiveSupport::TestCase
  def setup
    assert system("cd #{$test_app} && rake annotate > /dev/null")
  end

  test "annotating foo" do
    assert_equal File.read(asset_file 'foo_annotated.rb' ), File.read(app_file 'foo.rb' )
  end

  test "leaving existing comments" do
    FileUtils.cp asset_file('foo_annotated_with_comments.rb'), app_file('foo.rb')
    assert system("cd #{$test_app} && rake annotate")
    assert_equal File.read(asset_file 'foo_annotated_with_comments.rb' ), File.read(app_file 'foo.rb' )
  end

  def asset_file(name)
    File.join(File.expand_path("../assets/",  __FILE__), name)
  end

  def app_file(name)
    File.join($test_app,'app','models',name)
  end
end
