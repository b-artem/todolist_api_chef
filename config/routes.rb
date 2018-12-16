Rails.application.routes.draw do
  apipie
  scope '/api/v1' do
    mount_devise_token_auth_for 'User', at: 'auth'
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :projects, only: %i[index create update destroy] do
        resources :tasks, only: %i[index create update destroy] do
          resources :comments, only: %i[index create destroy]
        end
      end
    end
  end
end
