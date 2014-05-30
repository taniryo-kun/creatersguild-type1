class AddDetailsToTools < ActiveRecord::Migration
  def change
    add_column :tools, :category, :string
    add_column :tools, :tool_img, :string
  end
end
