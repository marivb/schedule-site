Rails.application.routes.draw do
  root 'static_pages#index'

  get '/organizer' => 'organizer_app#home'

  namespace :api, defaults: {format: :json} do
    resources :schedules, only: [:show] do
      resources :sessions, only: [:index, :create]
    end
  end
end
