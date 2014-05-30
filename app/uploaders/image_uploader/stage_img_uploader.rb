# encoding: utf-8

class ImageUploader::StageImgUploader < ImageUploader
  process :rotateByExif
  process :cropTheImage
  process :resizeTheImage => [1280, 960]
  process :convert => 'jpg'
end
