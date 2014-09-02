Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root 'static_pages#index'

  get '/organizer/schedules/:id' => 'organizer_app#schedule'

  namespace :api, defaults: {format: :json} do
    resources :schedules, only: [:show] do
      resources :sessions, only: [:index, :create]
    end
  end
end
