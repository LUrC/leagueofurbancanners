Lurc::Application.routes.draw do

  devise_for :users
  resources :users, :only => [:edit, :update]

  resources :prunings
  resources :cannings
  resources :canning_sessions
  resources :harvestings
  resources :harvests
  resources :status_checks
  resources :fruit_trees
  resources :fruits
  resources :sites do
    collection do
        get 'map'
        get 'clear_filters'
    end
  end

  resources :people do
    member do
        get 'merge'
        post 'commit_merge'
    end
  end


  authenticated :user do
    root :to => "sites#index"
  end

  root :to => 'home#index'

  # ComfyBlog::Routing.admin
  # ComfyBlog::Routing.content

  # ComfortableMexicanSofa::Routing.admin   :path => '/cms-admin'
  # ComfortableMexicanSofa::Routing.content :path => '/', :sitemap => false
end
