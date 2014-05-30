class Image::KnowledgeImage < Image
  mount_uploader :image, ImageUploader::KnowledgeImgUploader
end