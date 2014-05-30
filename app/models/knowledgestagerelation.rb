class Knowledgestagerelation < ActiveRecord::Base
  attr_accessible :knowledge_id, :workstage_id
  belongs_to :knowledge
  belongs_to :workstage

  validates :knowledge_id, :presence => true
  validates :workstage_id, :presence => true
end
