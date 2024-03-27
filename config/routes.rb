Rails.application.routes.draw do
  get 'search/index'
  get 'categories/index'
  get 'categories/list'
  get 'products/index'
  get 'products/show'
  get 'products/cart'
  get 'products/cart_remove'
  root 'home#index'
end