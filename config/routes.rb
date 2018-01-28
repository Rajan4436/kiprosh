Rails.application.routes.draw do
  get 'home/index'

  resources :notes
  devise_for :users, controllers: { registrations: "registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  post '/tags/remove', to: "tags#remove"
  post '/share', to: "notes#share"
  post '/search', to: "notes#search"
  post '/remove-share', to: "notes#remove_share"
end
