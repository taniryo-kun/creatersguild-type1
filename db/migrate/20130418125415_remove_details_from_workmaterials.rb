class RemoveDetailsFromWorkmaterials < ActiveRecord::Migration
  def up
    remove_column :workmaterials, :book
  end

  def down
    add_column :workmaterials, :book, :string
  end
end
