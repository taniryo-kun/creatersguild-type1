class CreateWorktags < ActiveRecord::Migration
  def change
    create_table :worktags do |t|
      t.integer :work_id	#作品識別子
      t.string :tag			#タグ名
      t.timestamps
    end
  end
end
