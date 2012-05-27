class AddAttachmentAvatarToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :avatar_file_name, :string
    add_column :papers, :avatar_content_type, :string
    add_column :papers, :avatar_file_size, :integer
    add_column :papers, :avatar_updated_at, :datetime
  end

  def self.down
    remove_column :papers, :avatar_file_name
    remove_column :papers, :avatar_content_type
    remove_column :papers, :avatar_file_size
    remove_column :papers, :avatar_updated_at
  end
end
