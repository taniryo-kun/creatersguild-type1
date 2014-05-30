class AddAfterImgToWorkstage < ActiveRecord::Migration
  def change
    add_column :workstages, :after_img, :string
  end
end
