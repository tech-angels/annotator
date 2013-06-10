class CreateRoos < ActiveRecord::Migration
  def change
    create_table :roos do |t|
      t.integer :boo_id
      t.integer :poly_id
      t.string  :poly_type
      t.integer :foo_id
      t.timestamps :null => false
    end
  end
end
