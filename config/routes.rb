Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :ping, only: [:index]
    end
  end

  resources :dispensers, path: 'dispenser', controller: 'api/v1/dispensers', only: :create
end
