require 'api/v1/task_update'

class API::V1::TasksController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project

  resource_description do
    api_version '1.0'
    short 'Current project tasks'
    formats ['json']
    error code: 400, desc: 'Bad Request'
    error code: 401, desc: 'Unauthorized'
    error code: 403, desc: 'Forbidden'
    error code: 404, desc: 'Not Found'
    error code: 422, desc: 'Unprocessable Entity'
  end

  def_param_group :project_id do
    param :project_id, :number, desc: 'ID of a Project which given Task belongs to',
          required: true
  end

  def_param_group :ids do
    param_group :project_id
    param :id, :number, desc: 'Task ID', required: true
  end

  def_param_group :task do
    param :task, Hash, desc: 'Task info', required: true, action_aware: true do
      param :name, String, desc: 'Name of a Task', required: true, action_aware: true
      param :done, [true, false], desc: 'Whether a Task is done or not (default value)'
      param :deadline, String, desc: 'Deadline for a Task in datetime format (nil by default)'
    end
  end

  api :GET, '/v1/projects/:project_id/tasks', 'Get a given Project all Tasks'
  param_group :project_id
  def index
    render json: @tasks, status: :ok
  end

  api :POST, '/v1/projets/:project_id/tasks', 'Create a new Task in a given Project'
  param_group :project_id
  param_group :task
  def create
    return render json: @task, status: :created if @task.save
    render json: @task.errors.full_messages, status: :unprocessable_entity
  end

  api :PUT, '/v1/projects/:project_id/tasks/:id', 'Update a Task'
  api :PATCH, '/v1/projects/:project_id/tasks/:id', 'Update a Task'
  param_group :ids
  param_group :task
  param :change_priority, %w[up down], desc: 'Change priority of a Task by one '\
        'step: "up" means higher priority, "down" - lower'
  def update
    task_update = API::V1::TaskUpdateService.new(task: @task,
      task_params: task_params, change_priority: params[:change_priority])
    return render json: @task, status: :ok if task_update.call
    render json: @task.errors.full_messages, status: :unprocessable_entity
  end

  api :DELETE, '/v1/projects/:project_id/tasks/:id', 'Delete a Task'
  param_group :ids
  def destroy
    @task.destroy
    head :no_content
  end

  private

  def task_params
    params.require(:task).permit(:name, :done, :deadline)
  end
end
