class CreateToolstagerelations < ActiveRecord::Migration
  def change
    create_table :toolstagerelations do |t|
      t.integer :workstage_id
      t.integer :tool_id

      t.timestamps
    end
  end
end
