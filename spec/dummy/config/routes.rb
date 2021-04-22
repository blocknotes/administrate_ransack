Rails.application.routes.draw do
  namespace :admin do
    resources :authors
    resources :profiles
    resources :posts
    resources :pictures
    resources :tags

    root to: 'posts#index'
  end

  root to: redirect('/admin')
end
