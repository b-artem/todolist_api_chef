class API::V1::CommentsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :task, through: :project
  load_and_authorize_resource through: :task

  resource_description do
    api_version '1.0'
    short 'Current task comments'
    formats ['json']
    error code: 400, desc: 'Bad Request'
    error code: 401, desc: 'Unauthorized'
    error code: 403, desc: 'Forbidden'
    error code: 404, desc: 'Not Found'
    error code: 422, desc: 'Unprocessable Entity'
  end

  def_param_group :project_task_ids do
    param :project_id, :number, desc: 'Project ID', required: true
    param :task_id, :number, desc: 'ID of a Task, which comments belong to',
          required: true
  end

  def_param_group :ids do
    param_group :project_task_ids
    param :id, :number, desc: 'Comment ID', required: true
  end

  def_param_group :comment do
    param :comment, Hash, desc: 'Comment info', required: true, action_aware: true do
      param :text, String, desc: 'Comment text', required: true, action_aware: true
      param :attachment, String, desc: 'Comment attachment - Base64 encoded '\
            'image in one of the following formats: .jpg/.jpeg/.png'
    end
  end

  api :GET, '/v1/projects/:project_id/tasks/:task_id/comments',
      'Get all comments of given Task'
  param_group :project_task_ids
  def index
    render json: @comments, status: :ok
  end

  api :POST, '/v1/projects/:project_id/tasks/:task_id/comments/',
      'Create a new Comment to a given Task'
  param_group :project_task_ids
  param_group :comment
  def create
    return render json: @comment, status: :created if @comment.save
    render json: @comment.errors.full_messages, status: :unprocessable_entity
  end

  api :DELETE, '/v1/projects/:project_id/tasks/:task_id/comments/:id',
      'Delete a comment'
  param_group :ids
  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def comment_params
    params.require(:comment).permit(:text, :attachment)
  end
end
