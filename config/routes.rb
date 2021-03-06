# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :pixel_cells, only: :index
      resources :live_cells, only: :show
      resources :pixel_cell_recordings, only: :index
      resources :ipo_events, only: :index
    end
  end
end
