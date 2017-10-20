Rails.application.routes.draw do
  root to: 'shots#index'

  resources :shots, only: [:index, :show, :create, :destroy]

  resources :users, only: [:show, :create] do
    collection do
      get 'current'

      post 'token' => 'user_token#create'
      post 'token/refresh' => 'user_token#refresh'
    end

    resources :shots, only: [:index, :show, :create, :destroy]
  end
end
