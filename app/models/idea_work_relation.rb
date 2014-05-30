class IdeaWorkRelation < ActiveRecord::Base
  attr_accessible :idea_id, :work_id
  belongs_to :idea
  belongs_to :work

  validates :idea_id, :presence => true
  validates :work_id, :presence => true
end
