Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  resources :books, except: [:edit] do
    resources :cards, only: [:new, :create]
    member do
      get :study
    end
  end
  resources :cards, except: [:show]
  get "/books/:id/study", to: "books#study", as: :study
end
