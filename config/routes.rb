Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root 'static_pages#index'

  get '/organizer/schedules/:id' => 'organizer_app#schedule'

  namespace :api, defaults: {format: :json} do
    resources :schedules, only: [:show, :update] do
      resources :sessions, only: [:index, :create]
      resources :rooms, only: [:index]
    end
  end
end
