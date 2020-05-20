Rails.application.routes.draw do
 
 root to: 'novels#index'
 
 get 'login', to: 'sessions#new'
 post 'login', to: 'sessions#create'
 delete 'logout', to: 'sessions#destroy'
 
 get 'signup', to: 'users#new'
 resources :users do
    member do
      get :relaied
      get :followings
      get :followers
      get :likes
    end
  end
 
 get 'novels/unfinished', to: 'novels#unfinished'
 get 'novels/ranking', to: 'novels#ranking'
 get 'novels/following_novels', to: 'novels#following_novels'
 get 'novels/about', to: 'novels#about'
 get 'novels/qanda', to: 'novels#qanda'
 get 'novels/guideline', to: 'novels#guideline'
 get 'novels/rule', to: 'novels#rule'
 get 'novels/ranking_relay', to: 'novels#ranking_relay'
 get 'novels/following_relay', to: 'novels#following_relay'
 resources :novels do
  member do
    get :continue
    get :last
  end
  resources :comments, only: [:create, :destroy]
 end
 
 resources :relationships, only: [:create, :destroy]
 resources :favorites, only: [:create, :destroy]
end
