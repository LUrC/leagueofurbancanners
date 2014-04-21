Lurc::Application.routes.draw do

  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :users, :only => [:edit, :update]

  resources :prunings
  resources :cannings
  resources :canning_sessions
  resources :harvests do
      resources :harvestings
  end
  resources :status_checks
  resources :fruit_trees
  resources :fruits
  resources :sites do
    collection do
        get 'map'
        get 'clear_filters'
    end
    member do
      get 'coordinate'
    end
  end

  resources :people do
    resources :harvests, :only => [:index]
    resources :harvestings
    member do
        get 'merge'
        post 'commit_merge'
        get 'site_chooser'
    end
  end


  authenticated :user do
    root :to => "home#member_index"
  end

  root :to => 'home#index'

  # ComfyBlog::Routing.admin
  # ComfyBlog::Routing.content

  # ComfortableMexicanSofa::Routing.admin   :path => '/cms-admin'
  # ComfortableMexicanSofa::Routing.content :path => '/', :sitemap => false
end
