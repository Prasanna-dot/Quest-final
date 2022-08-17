# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#new'
  get '/home', to: 'home#index'
  get '/assessment', to: 'home#assessment'
  resources :users
  resources :answers
  resources :questions, only: %i[create destroy]
  resources :sessions, only: %i[new create destroy]
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'forgot', to: 'sessions#forgot',  as: 'forgot'
  match '/forgot', to: 'sessions#forgot_password', via: :post
  get '/reset', to: 'sessions#reset', as: 'reset'
  get '/resend', to: 'sessions#resend', as: 'resend'
  match '/password_reset', to: 'sessions#password_reset', via: :get
  match '/password_reset', to: 'sessions#password_reset', via: :post
  get '/reset_password', to: 'sessions#reset_password', as: 'reset_password'
  match '/set_password', to: 'sessions#set_password', via: :get
  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/settings', to: 'users#edit', as: 'edit'
  get '/contact', to: 'home#contact', as: 'contact'
  match '/update', to: 'users#update', via: :post
  get '/delete_profile', to: 'users#delete_profile', as: 'delete_profile'
  get '/game_create', to: 'home#create_game',  as: 'create_game'
  get '/start/:title', to: 'home#start_game',  as: 'start_game'
  get '/stop/:title', to: 'home#stop_game', as: 'stop_game'
  get '/question/:title', to: 'questions#index'
  get '/questions', to: 'questions#create', as: 'create'
  match '/question', to: 'questions#index', via: :get
  match '/game', to: 'answers#index', via: :get
  match '/dashboard', to: 'home#dashboard', via: :get
  get '/questions/:id', to: 'questions#destroy'
  get '/dashboard/:title', to: 'home#dashboard', as: :dashboard
  get '/interview', to: 'home#interview'
  get 'login/create', to: 'logins#create', as: :create_login
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
