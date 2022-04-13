Rails.application.routes.draw do
  get 'static_pages/disclaimer'
  get 'static_pages/privacy'
  devise_for :users
  root 'posts#index'
  resources :posts, except: :show do
    collection do
      get 'search'
      get 'select'
      get 'kana'
    end
  end
end
