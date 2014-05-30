class Workstage < ActiveRecord::Base
  attr_accessible :workmaterial_ids, :knowledge_ids, :tool_ids, :work_id, :stage_num, :stage_pr, :stage_title, :start_image, :start_image_attributes, :after_image, :after_image_attributes
  belongs_to :work
  has_many :points
  has_many :comments, :as => :commentable
  has_many :knowledgestagerelations
  has_many :materialstagerelations
  has_many :toolstagerelations
  has_many :knowledges, :through => :knowledgestagerelations
  has_many :workmaterials, :through => :materialstagerelations
  has_many :tools, :through => :toolstagerelations
  
  has_one :start_image, :class_name => 'Image::StartImage', :as => :parent
  accepts_nested_attributes_for :start_image
  
  has_one :after_image, :class_name => 'Image::AfterImage', :as => :parent
  accepts_nested_attributes_for :after_image

  validates_presence_of :stage_title, :message => "please enter the title!"
  validates_presence_of :start_image, :message => "please set a image!"
  validates_presence_of :stage_pr, :message => "please comment something!"
end
