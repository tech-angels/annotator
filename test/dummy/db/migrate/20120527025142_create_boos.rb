class CreateBoos < ActiveRecord::Migration
  def change
    create_table :boos do |t|
      t.references :foo
      t.timestamps
    end
  end
end
