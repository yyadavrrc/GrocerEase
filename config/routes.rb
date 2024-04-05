Rails.application.routes.draw do
  get 'user/index'
  devise_for :users
  get 'cart/add_to_cart'
  get 'cart/remove_from_cart'
  get 'cart/update_cart'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'home#index'
  get '/Products/index', to:'products#index'
  get '/Products/show', to:'products#show'
  get '/Products/cart', to:'cart#show'
  get '/Products/cartRemove', to:'products#cartRemove'
  get '/Categories/index', to:'categories#index'
  get '/Categories/list', to:'categories#list'
  get '/Search/result', to:'search#index'
  get '/Contact', to:'home#show'
  get '/account', to:'user#index'
  patch '/update', to:'user#update'

  get '/view_cart', to: 'cart#view_cart'
  delete '/remove_from_cart/:id', to: 'cart#remove_from_cart', as: 'remove_from_cart'
  post '/add_to_cart', to: 'cart#add_to_cart', as: 'add_to_cart'
  patch '/update_cart/:id', to: 'cart#update_cart', as: 'update_cart'
  post '/checkout', to: 'cart#checkout'
  get '/users/sign_out', to:'user#sign_out'
end