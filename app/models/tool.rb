class Tool < ActiveRecord::Base
  attr_accessible :product_url, :section, :title, :category, :tool_image, :tool_image_attributes
  #mount_uploader :tool_img, ToolImgUploader
  has_many :toolstagerelations
  has_many :workstages, :through => :toolstagerelations
  has_many :usertoolrelations
  has_many :users, :through => :usertoolrelations

  has_one :tool_image, :class_name => "Image::ToolImage", :as => :parent
  accepts_nested_attributes_for :tool_image

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
      return Workstage.joins(:toolstagerelations).where("workstage_id IN (?)", workstage_ids).all
    end
  end
end
