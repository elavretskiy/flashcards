Rails.application.routes.draw do
  root 'home#index'

  resources :cards
  resources :user_sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :destroy]

  resources :blocks do
    put 'set_as_current', on: :member
    put 'reset_as_current', on: :member
  end

  put 'review_card' => 'trainer#review_card'

  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback'
  get 'oauth/:provider' => 'oauths#oauth', as: :auth_at_provider

  get 'profile/:id/edit' => 'profile#edit', as: :edit_profile
  put 'profile/:id' => 'profile#update', as: :profile
  delete 'profile/:id' => 'profile#destroy'
end
