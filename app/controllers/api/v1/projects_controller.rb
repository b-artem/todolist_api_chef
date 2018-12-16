class API::V1::ProjectsController < ApplicationController
  load_and_authorize_resource

  resource_description do
    api_version '1.0'
    short 'Current user projects'
    formats ['json']
    error code: 400, desc: 'Bad Request'
    error code: 401, desc: 'Unauthorized'
    error code: 403, desc: 'Forbidden'
    error code: 404, desc: 'Not Found'
    error code: 422, desc: 'Unprocessable Entity'
  end

  def_param_group :id do
    param :id, :number, desc: 'Project ID', required: true
  end

  def_param_group :project do
    param :project, Hash, desc: 'Project info', required: true do
      param :name, String, desc: 'Name of the project', required: true
    end
  end

  api :GET, '/v1/projects', 'Get all current user projects'
  def index
    render json: @projects, status: :ok
  end

  api :POST, '/v1/projects', 'Create a new project'
  param_group :project
  def create
    @project.user = current_user
    return render json: @project, status: :created if @project.save
    render json: @project.errors.full_messages, status: :unprocessable_entity
  end

  api :PUT, '/v1/projects/:id', 'Update a project'
  api :PATCH, '/v1/projects/:id', 'Update a project'
  param_group :id
  param_group :project
  def update
    return render json: @project, status: :ok if @project.update(project_params)
    render json: @project.errors.full_messages, status: :unprocessable_entity
  end

  api :DELETE, '/v1/projects/:id', 'Delete a project'
  param_group :id
  def destroy
    @project.destroy
    head :no_content
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
