class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, -> { order(priority: :asc) }, dependent: :destroy

  validates :name, presence: true, length: { minimum: 1 },
                   uniqueness: { scope: :user, message: I18n
                                 .t('models.project.already_exists') }
end
