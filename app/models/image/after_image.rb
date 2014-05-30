class Image::AfterImage < Image
  mount_uploader :image, ImageUploader::StageImgUploader
  validates :image, :presence => true
end