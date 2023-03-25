Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :ping, only: [:index]
    end
  end

  resources :dispensers, path: 'dispenser', controller: 'api/v1/dispensers', only: :create do
    member do
      put :update, path: 'status', controller: 'api/v1/dispensers/statuses'
      get :show, path: 'spending', controller: 'api/v1/dispensers/spendings'
    end
  end
end
