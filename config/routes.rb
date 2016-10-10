Rails.application.routes.draw do
  resources :comments
  resources :posts
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_scope :user do
  	get 'register', to: 'devise/registrations#new'
  	get 'login', to: 'devise/sessions#new'
  	get 'index', to: 'pages#index'
    get 'profile', to: 'users#show'

    authenticated :user do
      root 'pages#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

end
