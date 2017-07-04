Rails.application.routes.draw do
  get "/",  to: "rooms#index"

  resources :rooms, only: [:show, :index]
  resources :reservations, except: [:new, :edit]

end
