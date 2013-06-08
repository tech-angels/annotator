class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|

      t.timestamps :null => false
    end
  end
end
