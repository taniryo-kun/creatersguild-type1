class CreateMaterialstagerelations < ActiveRecord::Migration
  def change
    create_table :materialstagerelations do |t|
      t.integer :workmaterial_id
      t.integer :workstage_id

      t.timestamps
    end
  end
end
