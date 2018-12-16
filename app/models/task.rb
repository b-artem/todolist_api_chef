class Task < ApplicationRecord
  belongs_to :project
  acts_as_list scope: :project, column: :priority
  has_many :comments, dependent: :destroy

  validates :name, presence: true, length: { minimum: 1 },
            uniqueness: { scope: :project, message: I18n.t('models.task.already_exists') }
  validates :done, inclusion: { in: [true, false] }, allow_blank: true
end
