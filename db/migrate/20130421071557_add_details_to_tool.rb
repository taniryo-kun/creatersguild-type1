class AddDetailsToTool < ActiveRecord::Migration
  def change
    add_column :tools, :work_id, :integer
  end
end
