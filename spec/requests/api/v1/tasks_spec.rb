require "rails_helper"

RSpec.describe 'API::V1 Tasks', type: :request do
  let(:user) { create :user }
  let(:stranger_user) { create :user }
  let!(:project) { create(:project, user: user) }
  let!(:stranger_project) { create(:project, user: stranger_user) }
  let!(:tasks) { create_list(:task, 3, project: project) }
  let!(:stranger_tasks) { create_list(:task, 2, project: stranger_project) }
  let(:task) { tasks.sample }
  let(:stranger_task) { stranger_tasks.sample }
  let(:valid_attributes) { attributes_for :task }
  let(:invalid_attributes) { { name: '' } }

  describe 'GET #index' do
    context 'when guest user' do
      it 'returns http status code 401' do
        get api_v1_project_tasks_path(project)
        expect(response).to have_http_status 401
      end
    end

    context 'when user is signed in' do
      before do
        get api_v1_project_tasks_path(project), headers: user.create_new_auth_token
      end

      include_examples 'returns status code 200'
      include_examples 'returns response in JSON'
      include_examples 'matches response schema', :tasks

      it 'returns array of tasks which belong to given project only' do
        expect(json.size).to eq tasks.size
        expect(json.pluck('name')).to eq tasks.pluck(:name)
      end
    end
  end

  describe 'POST #create' do
    context 'when guest user' do
      before { post api_v1_project_tasks_path(project) }
      include_examples 'returns status code 401'
    end

    context 'when user is signed in' do
      context 'with valid params' do
        before do
          post api_v1_project_tasks_path(project),
          params: { task: valid_attributes },
          headers: user.create_new_auth_token
        end

        include_examples 'returns status code 201'
        include_examples 'returns response in JSON'
        include_examples 'matches response schema', :task

        it 'returns created task' do
          expect(json['name']).to eq valid_attributes[:name]
        end
      end

      context 'with invalid params' do
        before do
          post api_v1_project_tasks_path(project),
          params: { task: invalid_attributes },
          headers: user.create_new_auth_token
        end

        include_examples 'returns status code 422'
        include_examples 'returns validation failure message - blank', :name
      end
    end
  end

  describe 'PATCH #update' do
    context 'when guest user' do
      before { patch api_v1_project_task_path(project, task) }
      include_examples 'returns status code 401'
    end

    context 'when user is signed in' do
      context 'with valid params' do
        before do
          patch api_v1_project_task_path(project, task),
                params: { task: valid_attributes },
                headers: user.create_new_auth_token
        end

        include_examples 'returns status code 200'
        include_examples 'returns response in JSON'
        include_examples 'matches response schema', :task

        it 'returns updated task' do
          expect(json['name']).to eq valid_attributes[:name]
        end
      end

      context 'with invalid params' do
        before do
          patch api_v1_project_task_path(project, task),
                params: { task: invalid_attributes },
                headers: user.create_new_auth_token
        end

        include_examples 'returns status code 422'
        include_examples 'returns validation failure message - blank', :name
      end

      context 'task that user does NOT own' do
        before do
          patch api_v1_project_task_path(stranger_project, stranger_task),
                params: { task: valid_attributes },
                headers: user.create_new_auth_token
        end
        include_examples 'returns status code 403'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when guest user' do
      before { delete api_v1_project_task_path(project, task) }
      include_examples 'returns status code 401'
    end

    context 'when user is signed in' do
      before do
        delete api_v1_project_task_path(project, task),
        headers: user.create_new_auth_token
      end
      include_examples 'returns status code 204'
    end

    context 'task that user does NOT own' do
      before do
        delete api_v1_project_path(stranger_project),
               headers: user.create_new_auth_token
      end
      include_examples 'returns status code 403'
    end
  end
end
