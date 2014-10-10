Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static#index'
  # Static Landing, FAQ Pages
  get '/stories' => 'static#stories', :as => :stories
  get '/questions' => 'static#questions', :as => :questions
  get '/hosting' => 'static#hosting', :as => :hosting
  get '/about' => 'static#about', :as => :about
  get '/internproject' => 'static#internproject', :as => :internproject
  get '/birthdays' => 'static#birthdays', :as => :birthdays
  get '/openhouse' => 'static#openhouse', :as => :openhouse

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  devise_for :users, :controllers => {
    :registrations => "registrations",
    :confirmations => "confirmations"
  }, :skip => [:sessions]

  as :user do
    get 'signin' => 'devise/sessions#new', :as => :new_user_session
    post 'signin' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get 'logout' => 'devise/sessions#destroy'
    patch '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  end

  resources :tea_times do
    member do
      post '/attendance' => 'tea_times#create_attendance', as: :attendance
      put '/cancel' => 'tea_times#cancel', as: :cancel
      put '/attendance/:attendance_id' => 'tea_times#update_attendance',
        as: :update_attendance
    end
  end

  resources :cities do
    member do
      get '/host/:host_id' => 'hosts#show', as: :host
      get '/schedule', action: 'schedule', as: :schedule
    end
  end

  scope(path: 'admin')  do
    get '/ghost' => 'admin#find'
    post '/ghost' => 'admin#ghost'

    get '/overview' => 'admin#overview'
    get '/overview/hosts' => 'admin#host_overview'
    get '/users' => 'admin#users'

    get '/mail' => 'admin#write_mail'
    post '/mail' => 'admin#send_mail'
  end

  match '/profile' => 'profiles#show', as: :profile, via: :get
  get '/profile/history' => 'profiles#history', as: :history
  get '/host/new' => 'hosts#new', as: :new_host
  post '/host' => 'hosts#create', as: :create_host



  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
