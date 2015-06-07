Rails.application.routes.draw do
  filter :locale

  ActiveAdmin.routes(self)

  mount News::Engine => "/"

  root 'main#index'

  scope module: 'home' do
    resources :user_sessions, only: [:new, :create]
    resources :users, only: [:new, :create]
    get 'login' => 'user_sessions#new', :as => :login

    post 'oauth/callback' => 'oauths#callback'
    get 'oauth/callback' => 'oauths#callback'
    get 'oauth/:provider' => 'oauths#oauth', as: :auth_at_provider
  end

  scope module: 'dashboard' do
    resources :user_sessions, only: :destroy
    resources :users, only: :destroy
    post 'logout' => 'user_sessions#destroy', :as => :logout

    resources :cards do
      get 'get_flickr_images', on: :collection
      post 'parsing_html', on: :collection
    end

    resources :blocks do
      member do
        put 'set_as_current'
        put 'reset_as_current'
      end
    end

    put 'review_card' => 'trainer#review_card'
    get 'trainer' => 'trainer#index'

    get 'profile/:id/edit' => 'profile#edit', as: :edit_profile
    put 'profile/:id' => 'profile#update', as: :profile
    post 'invite_friends' => 'profile#invite_friends', as: :invite_friends
  end

  root to: redirect("/#{I18n.locale}", status: 302), as: :redirected_root
  get "/*path", to: redirect("/#{I18n.locale}/%{path}", status: 302),
      constraints: {path: /(?!(#{I18n.available_locales.join("|")})\/).*/},
      format: false
end
