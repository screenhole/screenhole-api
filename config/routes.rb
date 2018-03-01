Rails.application.routes.draw do
  root to: 'grabs#index'

  post '/svc/memo/voice' => 'services#voice_memo'

  resources :grabs, only: [:index, :show, :create, :destroy] do
    post 'report' => 'grabs#report'

    resources :memos, only: [:index, :show, :update, :create, :destroy]
  end

  resources :chomments, only: [:index, :create, :destroy]

  resources :invites, only: [:index, :create] do
    collection do
      get 'price' => 'invites#current_price'
    end
  end

  resources :users, only: [:show, :create] do
    post 'block' => 'users#block'
    post 'unblock' => 'users#unblock'

    collection do
      get 'current' => 'users#current'
      post 'current' => 'users#update'

      post 'token' => 'user_token#create'
      get 'token/refresh' => 'users#refresh_token'
    end

    resources :grabs, only: [:index, :show]
  end

  post '/shots' => 'grabs#create'
end
