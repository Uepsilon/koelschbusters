Koelschbusters::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  match 'ckeditor/pictures/:id/:style' => "ckeditor/pictures#show", via: :get
  Ckeditor::Engine.routes.prepend do
    resources :pictures, only: [:index, :destroy, :create]
  end

  root to: "news#index"

  get   :imprint,     to: "pages#imprint",      as: :imprint,     path: "impressum"
  get   :about,       to: "pages#about",        as: :about,       path: "ueber-uns"
  get   :management,  to: "pages#management",   as: :management,  path: "vorstand"
  get   :carnival_float, to: "pages#carnival_float",  as: :carnival_float, path: "wagenbau"

  resource :contact, only: :create, path: "kontakt"
  get "kontakt", to: "contacts#new", as: :contact

  devise_for :users, path: '', path_names: {sign_in: 'login', sign_out: 'logout'}, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  devise_scope :users do
    get :edit_login,   to: "users#edit_login",    path: "profil/login"
    put :update_login, to: "users#update_login", path: "profil/login"
    match   "profil/:provider" => "users#remove_oauth",   via: :delete,  as: :delete_oauth
  end

  resources :news, only: [:index, :show], path: "news" do
    resources :news_comments, except: [:new, :index, :show]
  end
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

    resources :news_comments, only: [:index, :destroy] do
      member do
        put 'activate'
        put 'deactivate'
      end
    end


    get "news(/kategorie/:category)(/seite/:page)", to: "news#index", as: :categorized_news

    resources :users, except: :show
    resources :galleries, except: :show do
      resources :pictures, except: :show do
        member do
          match :publish, via: :put
          match :unpublish, via: :put
        end
      end
    end

    resources :categories, except: :show
  end

  match '/401', to: 'errors#access_denied'
  match '/404', to: 'errors#not_found'
  match '/422', to: 'errors#unprocessable_entity'
  match '/500', to: 'errors#server_error'
end
