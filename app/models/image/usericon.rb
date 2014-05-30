class Image::Usericon < Image
	mount_uploader :image, ImageUploader::UsericonUploader
	validates :image, :presence => true
end