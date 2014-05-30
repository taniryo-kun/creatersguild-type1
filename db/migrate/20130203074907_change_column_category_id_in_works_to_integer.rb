class ChangeColumnCategoryIdInWorksToInteger < ActiveRecord::Migration
  def change
  	change_column :works, :category_id, :integer
  end
end
