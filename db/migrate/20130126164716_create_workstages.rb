class CreateWorkstages < ActiveRecord::Migration
  def change
    create_table :workstages do |t|
      t.integer :work_id	#作品識別子
      t.integer :stage_num	#作品毎工程番号
      t.string :stage_img	#工程画像
      t.string :stage_pr	#工程コメント
      t.timestamps
    end
  end
end
