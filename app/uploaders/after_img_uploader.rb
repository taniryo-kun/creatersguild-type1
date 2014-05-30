# encoding: utf-8

class AfterImgUploader < ImgUploader
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    binding.pry
  end

end