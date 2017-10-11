Rails.application.routes.draw do
  root to: 'shots#index'

  resources :shots, only: [:index, :show, :create, :destroy]

  post 'user_create' => 'users#create'
  post 'user_token' => 'user_token#create'
end
