class Usertoolrelation < ActiveRecord::Base
  attr_accessible :tool_id, :user_id
  belongs_to :user
  belongs_to :tool

  validates :tool_id, :presence => true
  validates :user_id, :presence => true
end
