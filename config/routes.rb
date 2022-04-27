Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :histogram_words, only: [:create, :show]
    end
  end
end
