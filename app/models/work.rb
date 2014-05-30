class Work < ActiveRecord::Base
  attr_accessible :title, :work_pr, :start_date, :work_point, :want_point, :good_point, :status, :category_id, :user_id, :idea_id
  attr_accessor :idea_id 
  belongs_to :user
  belongs_to :category
  has_many :workmaterials
  has_many :workstages
  has_many :worktags
  has_many :idea_work_relations
  validates :title, :presence => true
  validates :work_pr, :presence => true
  validates :category, :presence => true

  def self.search(search)
  	@result = Work.where(['title like ? or category like ?', "%#{search}%", "%#{search}%"]).all
  	return @result
  end

  def self.setcat(newcat)
      #入力されたものが既存のカテゴリであった場合
      if catfound = Category.find_by_category_name(newcat)
        #見つかったカテゴリのidをcategory_idに挿入
        category_id = catfound.id
      #入力されたものが新しいカテゴリであった場合
      else
        @newcat = Category.new(:category_name => newcat)
        @newcat.save
        #新しく登録したカテゴリのidをcategory_idに挿入
        category_id = @newcat.id
      end
      return category_id
  end
  
  def tools
    Tool.joins(:toolstagerelations).where("workstage_id IN (?)", self.workstage_ids).uniq.all
  end

  def knowledges
    Knowledge.joins(:knowledgestagerelations).where("workstage_id IN (?)", self.workstage_ids).uniq.all
  end

end
