class Image < ActiveRecord::Base
  attr_accessible :image, :image_cache, :parent_id, :parent_type, :type, :left, :top, :width, :height
  attr_accessor :left, :top, :width, :height
  belongs_to :parent, :polymorphic => true
end
