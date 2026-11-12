Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users
  resources :species
  resources :patients do
    collection do
      post :import
    end
    resources :medical_records
    resources :vaccinations
  end

  root "patients#index"
end
