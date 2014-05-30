class AddDetailsToWorkstages < ActiveRecord::Migration
  def change
    add_column :workstages, :stage_title, :string
  end
end
