class Knowledge < ActiveRecord::Base
  attr_accessible :category, :product_url, :ref_work, :section, :title, :knowledge_image, :knowledge_image_attributes
  mount_uploader :knowledge_img, KnowledgeImgUploader
  has_many :knowledgestagerelations
  has_many :workstages, :through => :knowledgestagerelations
  has_many :userknowledgerelations
  has_many :users, :through => :userknowledgerelations

  has_one :knowledge_image, :class_name => "Image::KnowledgeImage", :as => :parent
  accepts_nested_attributes_for :knowledge_image

  validates :title, :presence => true, :uniqueness => true

  # workstagesメソッドをオーバーライド。
  # ハッシュ形式で引数に
  # :work => 「Specific Work」
  # と与えることで特定のworkに関連したworkstagesを取得可能に。
  def workstages(args = {})
    work = args[:work] || nil
    if not work
      return super
    else
      workstage_ids = work.workstage_ids & self.workstage_ids
      return Workstage.joins(:knowledgestagerelations).where("workstage_id IN (?)", workstage_ids).all
    end
  end
end
