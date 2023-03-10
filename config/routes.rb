Rails.application.routes.draw do
  devise_for :users
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  resources :books, except: [:edit] do
    resources :cards, only: [:new, :create, :destroy]
    member do
      get :study
    end
  end

  resources :cards, except: [:show]
  get "/books/:id/study", to: "books#study", as: :study
end
