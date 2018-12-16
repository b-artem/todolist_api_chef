class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at
  has_many :tasks
end
