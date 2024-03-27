Rails.application.routes.draw do
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
end