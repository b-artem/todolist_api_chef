class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :done, :deadline, :created_at, :project_id, :priority, :comments
  has_many :comments
end
