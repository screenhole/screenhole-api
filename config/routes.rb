Rails.application.routes.draw do
  root to: 'shots#index'

  resources :shots, only: [:index, :show, :create, :destroy]

  resources :users, only: [:show, :create] do
    resources :shots, only: [:index, :show, :create, :destroy]
  end

  post 'user_token' => 'user_token#create'
end
