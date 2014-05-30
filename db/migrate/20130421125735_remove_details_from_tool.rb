class RemoveDetailsFromTool < ActiveRecord::Migration
  def up
    remove_column :tools, :work_id
  end

  def down
    add_column :tools, :work_id, :integer
  end
end
