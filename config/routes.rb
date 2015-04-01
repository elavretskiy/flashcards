Rails.application.routes.draw do
  root 'home#index'

  resources :cards
  put 'review_card' => 'trainer#review_card'

  resources :user_sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :destroy]

  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback'
  get 'oauth/:provider' => 'oauths#oauth', as: :auth_at_provider

  get 'profile/:id/edit' => 'profile#edit', as: :edit_profile
  put 'profile/:id' => 'profile#update', as: :profile
  delete 'profile/:id' => 'profile#destroy'

  resources :blocks
  put 'blocks/:id/set_as_current' => 'blocks#set_as_current', as: :block_set_as_current
  put 'blocks/:id/reset_as_current' => 'blocks#reset_as_current', as: :block_reset_as_current
end
