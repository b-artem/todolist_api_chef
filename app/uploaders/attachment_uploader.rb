class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog

  def store_dir
    "public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :preview do
    process resize_to_fit: [200, 200]
  end

  def extension_whitelist
    %w(jpg jpeg png)
  end
end
