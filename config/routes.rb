Rails.application.routes.draw do
  namespace :admin do
    resources :messages
  end

  resources :admin
end
