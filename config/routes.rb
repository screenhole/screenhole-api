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

  namespace :api do
    namespace :v2 do
      # new for multi-hole
      resources :holes, only: %i[create show update] do
        # replaces /grabs
        resources :grabs, only: %i[index show create] # TODO: destroy, report, comments, tips

        # replaces /chomments
        resources :chat_messages, only: %i[index create destroy]
      end

      # new for multi-hole
      resources :upload_tokens, only: %i[create]

      # replaces /sup
      resources :notifications, only: %i[index]
    end
  end

  root to: 'grabs#index'

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

  # for old clients
  post '/shots' => 'grabs#create'
end
