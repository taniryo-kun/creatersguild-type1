class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null:false #ユーザ名
      t.string :email			#メールアドレス
      t.integer :cpoint			#クリエーターズポイント
      t.string :creaters_url	#ユーザのホームページ
      t.string :icon_img		#アイコン画像
      t.text :pr_msg			#自己紹介メッセージ
      t.timestamps
    end
  end
end
