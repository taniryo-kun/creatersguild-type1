class CreateUsertoolrelations < ActiveRecord::Migration
  def change
    create_table :usertoolrelations do |t|
      t.integer :user_id
      t.integer :tool_id

      t.timestamps
    end
  end
end
