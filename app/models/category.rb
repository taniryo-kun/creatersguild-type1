#coding: utf-8
class Category < ActiveRecord::Base
  attr_accessible :category_name
  has_many :works

  validates :category_name, :presence => true,  :uniqueness => true

  #なぜか動かないのでとりあえず放置
  def self.newcat(cat)
  	#カテゴリに既に登録されていなければ新しいカテゴリを追加
  	if @catfound = self.where(['category_name = ?', cat])
  		return @catfound
  	else
  		@newcat = self.new(:category_name => cat)
  		if @newcat.save
  			return @newcat
  		else
  			redirect_to :root, notice: "カテゴリ登録において障害発生"
  		end
  	end
  end
end
