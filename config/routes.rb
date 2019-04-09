Rails.application.routes.draw do
  namespace :admin do
    resources :buttcoins, only: %i(index show new create edit update destroy)
    resources :chomments, only: %i(index show new create edit update destroy)
    resources :grabs, only: %i(index show new create edit update destroy)
    resources :users, only: %i(index show new create edit update destroy)
    resources :holes, only: %i(index show new create edit update destroy)
    resources :invites, only: %i(index show new create edit update destroy)
    resources :memos, only: %i(index show new create edit update destroy)
    resources :notes, only: %i(index show new create edit update destroy)

    root to: 'users#index'
  end

  root to: 'grabs#index'

  get '/sup/any' => 'notes#any'
  get '/sup' => 'notes#index'

  get '/svc/buttcoin/market_cap' => 'services#buttcoin_market_cap'

  post '/svc/memo/voice' => 'services#voice_memo'

  get '/buttcoins', to: 'buttcoins#index'
  get '/buttcoins/trends', to: 'buttcoins#trends'

  resources :holes, only: %i[create show]

  resources :upload_tokens, only: %i[create]

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

  resources :users, only: [:index, :show, :create] do
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

  resources :countries, only: [:index]

  # for old clients
  post '/shots' => 'grabs#create'
end
