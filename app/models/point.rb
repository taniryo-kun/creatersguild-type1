class Point < ActiveRecord::Base
  attr_accessible :workstage_id, :coordinateX, :coordinateY
  belongs_to :workstage
  has_many :comments

  validates :coordinateX, :coordinateY,
    :presence => {:message => 'is need item'},
    :numericality => {:greater_than => 0, :less_than => 100}
    
  def self.point_existence_chk (point)
  	cooX = point.coordinateX
  	cooY = point.coordinateY
  	workstage_id = point.workstage_id
  	if self.where("coordinateX = ? and coordinateY = ? and workstage_id = ?", cooX, cooY, workstage_id).present?
  		#既ポイントの場合
  		return false
  	else
  		#新規ポイントの場合
  		return true
  	end
  end
end
