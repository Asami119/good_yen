Rails.application.routes.draw do
  devise_for :users
  root 'posts#index'
  resources :posts, except: :show do
    collection do
      get 'search'
      get 'select'
    end
  end
end
