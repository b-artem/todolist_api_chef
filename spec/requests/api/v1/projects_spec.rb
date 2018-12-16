require "rails_helper"

RSpec.describe 'API::V1 Projects', type: :request do
  let(:user) { create :user }
  let(:stranger_user) { create :user }
  let!(:projects) { create_list(:project, 3, user: user) }
  let!(:stranger_projects) { create_list(:project, 2, user: stranger_user) }
  let(:project) { projects.sample }
  let(:stranger_project) { stranger_projects.sample }
  let(:valid_attributes) { attributes_for :project }
  let(:invalid_attributes) { { name: '' } }

  describe 'GET #index' do
    context 'when guest user' do
      it 'returns http status code 401' do
        get api_v1_projects_path
        expect(response).to have_http_status 401
      end
    end

    context 'when user is signed in' do
      before do
        get api_v1_projects_path, headers: user.create_new_auth_token
      end

      include_examples 'returns status code 200'
      include_examples 'returns response in JSON'
      include_examples 'matches response schema', :projects

      it 'returns array of projects which belong to signed in user only' do
        expect(json.size).to eq projects.size
        expect(json.pluck('name')).to eq projects.pluck(:name)
      end
    end
  end

  describe 'POST #create' do
    context 'when guest user' do
      before { post api_v1_projects_path }
      include_examples 'returns status code 401'
    end

    context 'when user is signed in' do
      context 'with valid params' do
        before do
          post api_v1_projects_path, params: { project: valid_attributes },
          headers: user.create_new_auth_token
        end

        include_examples 'returns status code 201'
        include_examples 'returns response in JSON'
        include_examples 'matches response schema', :project

        it 'returns created project' do
          expect(json['name']).to eq valid_attributes[:name]
        end
      end

      context 'with invalid params' do
        before do
          post api_v1_projects_path, params: { project: invalid_attributes },
          headers: user.create_new_auth_token
        end

        include_examples 'returns status code 422'
        include_examples 'returns validation failure message - blank', :name
      end
    end
  end

  describe 'PATCH #update' do
    context 'when guest user' do
      before { patch api_v1_project_path(project) }
      include_examples 'returns status code 401'
    end

    context 'when user is signed in' do
      context 'with valid params' do
        before do
          patch api_v1_project_path(project),
                params: { project: valid_attributes },
                headers: user.create_new_auth_token
        end

        include_examples 'returns status code 200'
        include_examples 'returns response in JSON'
        include_examples 'matches response schema', :project

        it 'returns updated project' do
          expect(json['name']).to eq valid_attributes[:name]
        end
      end

      context 'with invalid params' do
        before do
          patch api_v1_project_path(project),
                params: { project: invalid_attributes },
                headers: user.create_new_auth_token
        end

        include_examples 'returns status code 422'
        include_examples 'returns validation failure message - blank', :name
      end

      context 'project that user does NOT own' do
        before do
          patch api_v1_project_path(stranger_project),
                params: { project: valid_attributes },
                headers: user.create_new_auth_token
        end
        include_examples 'returns status code 403'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when guest user' do
      before { delete api_v1_project_path(project) }
      include_examples 'returns status code 401'
    end

    context 'when user is signed in' do
      before do
        delete api_v1_project_path(project), headers: user.create_new_auth_token
      end
      include_examples 'returns status code 204'
    end

    context 'project that user does NOT own' do
      before do
        delete api_v1_project_path(stranger_project),
               headers: user.create_new_auth_token
      end
      include_examples 'returns status code 403'
    end
  end
end
