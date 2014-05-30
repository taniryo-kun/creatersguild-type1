# encoding : utf-8

class ImageUploader::UsericonUploader < ImageUploader
	process :cropTheImage
	process :resizeTheImage => [500,500]
	process :convert => 'jpg'
end