Rails.application.routes.draw do
  devise_scope :user do
    get "users", to: "devise/sessions#new"
  end

  devise_for :users

  resources :locations, only: %i[index show create new destroy]

  root to: "locations#index"
end
