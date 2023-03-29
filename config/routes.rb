# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  namespace :admin do
    resources :messages
  end

  resources :admin
end
