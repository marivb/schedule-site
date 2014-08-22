Rails.application.routes.draw do
  get '/organizer' => 'organizer_app#home'

  root 'static_pages#index'
end
