class Toolstagerelation < ActiveRecord::Base
  attr_accessible :tool_id, :workstage_id
  belongs_to :workstage
  belongs_to :tool

  validates :tool_id, :presence => true
  validates :workstage_id, :presence => true
end
