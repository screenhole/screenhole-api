Rails.application.routes.draw do
  root to: 'shots#index'

  resources :shots, only: [:index, :show, :create, :destroy]

  resources :users, only: [:show, :create] do
    collection do
      get 'current'

      post 'token' => 'user_token#create'
      get 'token/refresh' => 'users#refresh_token'
    end

    resources :shots, only: [:index, :show, :create, :destroy]
  end
end
