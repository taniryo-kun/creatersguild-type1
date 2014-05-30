class Workmaterial < ActiveRecord::Base
  attr_accessible :work_id, :material, :amount
  belongs_to :work
  has_many :materialstagerelations
  has_many :workstages, :through => :materialstagerelations

  validates :material, :presence => true
end
