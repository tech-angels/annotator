class Paper < ActiveRecord::Base
  # has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  # stub for tests
  def self.attachment_definitions
    {:avatar=>{:styles=>{:medium=>"300x300>", :thumb=>"100x100>"}}} 
  end
end
