class CreateWorkmaterials < ActiveRecord::Migration
  def change
    create_table :workmaterials do |t|
      t.integer :work_id	#作品識別子
      t.string :material	#使用材料
      t.string :book		#参照資料
      t.timestamps
    end
  end
end
