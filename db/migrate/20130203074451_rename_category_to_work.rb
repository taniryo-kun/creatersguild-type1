class RenameCategoryToWork < ActiveRecord::Migration
  def change
  	rename_column :works, :category, :category_id
  end
end
