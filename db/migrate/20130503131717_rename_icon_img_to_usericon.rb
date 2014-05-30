class RenameIconImgToUsericon < ActiveRecord::Migration
  def change
  	rename_column :users, :icon_img, :usericon
  end
end
