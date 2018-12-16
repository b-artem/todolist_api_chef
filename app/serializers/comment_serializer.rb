class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :attachment, :task_id, :created_at
end
