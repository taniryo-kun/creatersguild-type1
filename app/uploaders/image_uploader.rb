# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cropTheImage
    manipulate! do |img|
      imgh = img.rows
      imgw = img.columns
      cropl = (imgw * model.left.to_f).round
      cropt = (imgh * model.top.to_f).round
      cropw = (imgw * model.width.to_f).round
      croph = (imgh * model.height.to_f).round
      binding.pry
      img = img.crop(cropl, cropt, cropw, croph)
    end
  end

  def resizeTheImage(w, h)
    manipulate! do |img|
      img = img.resize(w, h)
    end
  end

  def rotateByExif
    manipulate! do |img|
      img = img.auto_orient
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if super != nil
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

end
