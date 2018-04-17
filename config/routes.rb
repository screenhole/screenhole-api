Rails.application.routes.draw do
  root to: 'grabs#index'

  get '/sup/any' => 'notes#any'
  get '/sup' => 'notes#index'

  get '/svc/buttcoin/market_cap' => 'services#buttcoin_market_cap'

  post '/svc/memo/voice' => 'services#voice_memo'

  get '/buttcoins', to: 'buttcoins#index'
  get '/buttcoins/trends', to: 'buttcoins#trends'

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

  # for old clients
  post '/shots' => 'grabs#create'
end
