class Image::ToolImage < Image
  mount_uploader :image, ImageUploader::ToolImgUploader
end