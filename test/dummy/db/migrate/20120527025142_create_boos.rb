class CreateBoos < ActiveRecord::Migration
  def change
    create_table :boos do |t|
      t.references :foo
      t.integer :poly_id
      t.string :poly_type
      t.timestamps :null => false
    end
  end
end
