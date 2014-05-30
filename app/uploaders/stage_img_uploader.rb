# encoding: utf-8

class StageImgUploader < ImgUploader
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    binding.pry
  end
end
