class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment 			#コメント
      t.integer :point_id		#ポイント識別子
      t.integer :workstage_id	#工程識別子
      t.string :comment_status	#コメント意味
      t.timestamps
    end
  end
end
