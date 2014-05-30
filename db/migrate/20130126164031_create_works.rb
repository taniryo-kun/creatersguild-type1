class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :title		#作品タイトル
      t.string :work_pr		#作品PR
      t.string :start_date	#制作開始日
      t.integer :work_point	#作品総合ポイント
      t.integer :want_point	#欲しい数
      t.integer :good_point	#いいね数
      t.string :status		#作品ステータス
      t.string :category	#カテゴリ名
      t.string :user_id		#ユーザ識別子
      t.timestamps
    end
  end
end
