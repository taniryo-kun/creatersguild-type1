class Idea < ActiveRecord::Base
  attr_accessible :idea, :user_id
  has_many :idea_work_relations
  has_many :works, :through => :idea_work_relations
  validates :idea, :presence => true
end
