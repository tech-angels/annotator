class CreateFoos < ActiveRecord::Migration
  def change
    create_table :foos do |t|
      t.text :body
      t.string :title
      t.integer :random_number
      t.timestamps :null => false
    end
  end
end
