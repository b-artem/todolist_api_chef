class Comment < ApplicationRecord
  belongs_to :task
  mount_base64_uploader :attachment, AttachmentUploader
  
  validates :text, presence: true, length: { minimum: 1 }
end
