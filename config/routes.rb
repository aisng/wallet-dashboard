Rails.application.routes.draw do
  apipie
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      namespace :rpc do
        get 'resources', to: 'resources'
        post 'call', to: 'call'
        post ':chain/balance/:address', to: 'balance'
        post ':chain/tx_count/:address', to: 'tx_count'
        post ':chain/block/:block_number', to: 'block_by_number'
        get ':chain/current_block', to: 'block_number'
      end
    end
  end
end
