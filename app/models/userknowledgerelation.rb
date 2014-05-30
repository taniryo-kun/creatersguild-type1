class Userknowledgerelation < ActiveRecord::Base
  attr_accessible :knowledge_id, :user_id
  belongs_to :user
  belongs_to :knowledge

  validates :knowledge_id, :presence => true
  validates :user_id, :presence => true
end
