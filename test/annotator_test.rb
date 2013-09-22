require 'test_helper'
require 'tempfile'

class AnnotatorTest < ActiveSupport::TestCase
  def setup
    @output = execute("rake annotate")
  end

  test "annotating foo" do
    assert_equal File.read(asset_file 'foo_annotated.rb' ), File.read(app_file 'foo.rb' )
  end

  test "leaving existing comments" do
    FileUtils.cp asset_file('foo_annotated_with_comments.rb'), app_file('foo.rb')
    execute "rake annotate"
    assert_equal File.read(asset_file 'foo_annotated_with_comments.rb' ), File.read(app_file 'foo.rb' )
  end

  test "updating column type" do
    FileUtils.cp asset_file('foo_annotated_bad_column.rb'), app_file('foo.rb')
    output = execute "rake annotate"
    assert_equal File.read(asset_file 'foo_annotated_column_fixed.rb' ), File.read(app_file 'foo.rb' )
    assert output.include?('M Foo#title [octopus -> string]')
    assert output.include?('M Foo#created_at [foobar -> datetime, not null]')
  end

  test "skipping when nodoc is preesnt" do
    FileUtils.cp asset_file('foo_annotated_bad_column_nodoc.rb'), app_file('foo.rb')
    execute "rake annotate"
    assert_equal File.read(asset_file 'foo_annotated_bad_column_nodoc.rb' ), File.read(app_file 'foo.rb' )
  end

  # also tests multiline default values
  test "annotating devise columns" do
    assert_equal File.read(asset_file 'user_annotated.rb' ), File.read(app_file 'user.rb' )
  end

  test "annotating paperclip columns" do
    assert_equal File.read(asset_file 'paper_annotated.rb' ), File.read(app_file 'paper.rb' )
  end

  test "annotating belongs_to and polymorphic associations" do
    assert_equal File.read(asset_file 'boo_annotated.rb' ), File.read(app_file 'boo.rb' )
  end

  test "handling some code before annotitions block" do
    FileUtils.cp asset_file('foo_require_first.rb'), app_file('foo.rb')
    execute "rake annotate"
    assert_equal File.read(asset_file 'foo_require_first.rb' ), File.read(app_file 'foo.rb' )
  end

  test "leaving magic comments in place" do
    FileUtils.cp asset_file('boo_encoding.rb'), app_file('boo.rb')
    execute "rake annotate"
    assert_equal File.read(asset_file 'boo_encoding_annotated.rb' ), File.read(app_file 'boo.rb' )
  end

  test "annotating namespaced models" do
    assert_equal File.read(asset_file 'moo_hoo_annotated.rb' ), File.read(app_file 'moo/hoo.rb' )
  end

  test "reannotating belongs_to if it had default annotation" do
    assert_equal File.read(asset_file 'roo_reannotated.rb' ), File.read(app_file 'roo.rb' )
  end

  test "reannotating belongs_to output message" do
    FileUtils.cp asset_file('roo_initially_annotated.rb'), app_file('roo.rb')
    output = execute "rake annotate"
    assert output.include?('M Roo#boo_id description updated')
    assert output.include?('M Roo#poly_id description updated')
    assert output.include?('M Roo#poly_type description updated')
    assert !output.include?('M Roo#foo_id')
  end

  test "removing a deleted column" do
    FileUtils.cp asset_file('roo_annotated_with_old_column.rb'), app_file('roo.rb')
    output = execute "rake annotate"
    assert output.include?('D Roo#deleted_at')
    assert_equal File.read(asset_file 'roo_reannotated.rb' ), File.read(app_file 'roo.rb' )
  end

  def asset_file(name)
    File.join(File.expand_path("../assets/",  __FILE__), name)
  end

  def app_file(name)
    File.join(TestApp.path,'app','models',name)
  end

  # Check exit code while grabbing output
  def execute(command)
    tmp = Tempfile.new "output"
    assert system("cd #{TestApp.path} && #{command} > #{tmp.path}")
    output = tmp.read
    tmp.unlink
    output
  end
end
