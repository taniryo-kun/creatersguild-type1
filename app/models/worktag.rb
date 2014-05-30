class Worktag < ActiveRecord::Base
  attr_accessible :work_id, :tag
  belongs_to :work

  validates :tag, :presence => true
end
