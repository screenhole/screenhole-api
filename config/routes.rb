Rails.application.routes.draw do
  root to: 'shots#index'

  post '/svc/memo/voice' => 'services#voice_memo'

  resources :shots, only: [:index, :show, :create, :destroy] do
    resources :memos, only: [:index, :show, :update, :create, :destroy]
  end

  resources :chomments, only: [:index, :create, :destroy]

  resources :users, only: [:show, :create] do
    collection do
      get 'current' => 'users#current'
      post 'current' => 'users#update'

      post 'token' => 'user_token#create'
      get 'token/refresh' => 'users#refresh_token'
    end

    resources :shots, only: [:index, :show]
  end
end
