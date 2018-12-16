require "rails_helper"

RSpec.describe 'API::V1 Comments', type: :request do
  let(:user) { create :user }
  let(:stranger_user) { create :user }
  let(:project) { create(:project, user: user) }
  let(:stranger_project) { create(:project, user: stranger_user) }
  let(:task) { create(:task, project: project) }
  let(:stranger_task) { create(:task, project: stranger_project) }
  let!(:comments) { create_list(:comment, 3, task: task) }
  let!(:stranger_comments) { create_list(:comment, 2, task: stranger_task) }
  let(:comment) { comments.sample }
  let(:stranger_comment) { stranger_comments.sample }
  let(:valid_attributes) { attributes_for :comment }
  let(:invalid_attributes) { { text: '' } }

  describe 'GET #index' do
    context 'when guest user' do
      it 'returns http status code 401' do
        get api_v1_project_task_comments_path(project, task)
        expect(response).to have_http_status 401
      end
    end

    context 'when user is signed in' do
      before do
        get api_v1_project_task_comments_path(project, task),
        headers: user.create_new_auth_token
      end

      include_examples 'returns status code 200'
      include_examples 'returns response in JSON'
      include_examples 'matches response schema', :comments_text_only

      it 'returns array of comments which belong to given task only' do
        expect(json.size).to eq comments.size
        expect(json.pluck('text')).to eq comments.pluck(:text)
      end
    end
  end

  describe 'POST #create' do
    context 'when guest user' do
      before { post api_v1_project_task_comments_path(project, task) }
      include_examples 'returns status code 401'
    end

    context 'when user is signed in' do
      context 'with valid params' do
        before do
          post api_v1_project_task_comments_path(project, task),
          params: { comment: valid_attributes },
          headers: user.create_new_auth_token
        end

        include_examples 'returns status code 201'
        include_examples 'returns response in JSON'
        include_examples 'matches response schema', :comment_text_only

        it 'returns created comment' do
          expect(json['text']).to eq valid_attributes[:text]
        end
      end

      context 'with invalid params' do
        before do
          post api_v1_project_task_comments_path(project, task),
          params: { comment: invalid_attributes },
          headers: user.create_new_auth_token
        end

        include_examples 'returns status code 422'
        include_examples 'returns validation failure message - blank', :text
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when guest user' do
      before { delete api_v1_project_task_comment_path(project, task, comment) }
      include_examples 'returns status code 401'
    end

    context 'when user is signed in' do
      before do
        delete api_v1_project_task_comment_path(project, task, comment),
        headers: user.create_new_auth_token
      end
      include_examples 'returns status code 204'
    end

    context 'task that user does NOT own' do
      before do
        delete api_v1_project_task_comment_path(stranger_project,
               stranger_task, stranger_comment),
               headers: user.create_new_auth_token
      end
      include_examples 'returns status code 403'
    end
  end
end
