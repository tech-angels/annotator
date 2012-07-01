# Attributes:
# * id [integer, primary, not null] - primary key
# * avatar_content_type [string] - Paperclip for avatar
# * avatar_file_name [string] - Paperclip for avatar
# * avatar_file_size [integer] - Paperclip for avatar
# * avatar_updated_at [datetime] - Paperclip for avatar
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class Paper < ActiveRecord::Base
  # has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  # stub for tests
  def self.attachment_definitions
    {:avatar=>{:styles=>{:medium=>"300x300>", :thumb=>"100x100>"}}} 
  end
end
