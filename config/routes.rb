Koelschbusters::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  match 'ckeditor/pictures/:id/:style' => "ckeditor/pictures#show", via: :get
  Ckeditor::Engine.routes.prepend do
    resources :pictures, only: [:index, :destroy, :create]
  end

  root to: "news#index"

  get   :imprint, to: "pages#imprint",  as: :imprint,   path: "impressum"
  get   :about,   to: "pages#about",    as: :about,     path: "ueber-uns"
  post  :about,   to: "pages#contact",  as: :contact,   path: "ueber-uns"

  devise_for :users, path: '', path_names: {sign_in: 'login', sign_out: 'logout'}, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  devise_scope :users do
    get :edit_login,   to: "users#edit_login",    path: "profil/login"
    put :update_login, to: "users#update_login", path: "profil/login"
    match   "profil/:provider" => "users#remove_oauth",   via: :delete,  as: :delete_oauth
  end

  resources :news, only: [:index, :show], path: "news"
  get "news(/kategorie/:category)(/seite/:page)", to: "news#index", as: :categorized_news

  resource :user, only: [:show, :edit, :update], path: "profil"

  resources :galleries, only: [:index, :show], path: "galerie"
  match "galerie/:gallery_id/bild/:id(/:style)" => "pictures#show", via: :get, as: :picture, defaults: { style: :original }

  namespace :admin do
    root to: "pages#index"

    resources :news,  except: :show do
      member do
        put 'publish'
        put 'unpublish'
      end
    end
    get "news(/category/:category(/page/:page))", to: "news#index", as: :categorized_news

    resources :users, except: :show
    resources :galleries, except: :show do
      resources :pictures, except: :show
    end

    resources :categories, except: :show
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       news 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root to: 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
