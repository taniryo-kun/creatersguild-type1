class AddDetailsToWorkmaterials < ActiveRecord::Migration
  def change
    add_column :workmaterials, :amount, :integer
  end
end
