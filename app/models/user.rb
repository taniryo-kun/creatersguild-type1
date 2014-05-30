class User < ActiveRecord::Base
  attr_accessible :name, :email, :cpoint, :creaters_url, :usericon, :usericon_attributes, :pr_msg,:password,:password_confirmation, :redirectURL
  #mount_uploader :icon_img, IconImgUploader
  has_secure_password
  has_many :works
  has_many :comments
  has_many :userknowledgerelations
  has_many :knowledges, :through => :userknowledgerelations
  has_many :usertoolrelations
  has_many :tools, :through => :usertoolrelations

  has_one :usericon, :class_name => "Image::Usericon", :as => :parent
  accepts_nested_attributes_for :usericon

  validates :name, :presence => true, :uniqueness => true
  validates :password, :presence => true
  validates :email, :presence => true, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
end
