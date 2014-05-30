class Image::StartImage < Image
  mount_uploader :image, ImageUploader::StageImgUploader
  validates :image, :presence => true
end