class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|

      t.timestamps
    end
  end
end
