class Materialstagerelation < ActiveRecord::Base
  attr_accessible :workmaterial_id, :workstage_id
  belongs_to :workmaterial
  belongs_to :workstage

  validates :workmaterial_id, :presence => true
  validates :workstage_id, :presence => true
end
