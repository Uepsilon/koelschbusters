Koelschbusters::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  get 'ckeditor/pictures/:id/:style' => 'ckeditor/pictures#show'
  Ckeditor::Engine.routes.prepend do
    resources :pictures, only: %i(index destroy create)
  end

  root to: 'news#index'

  get :imprint, to: 'pages#imprint', as: :imprint, path: 'impressum'
  get :about, to: 'pages#about', as: :about, path: 'ueber-uns'
  get :management, to: 'pages#management', as: :management, path: 'vorstand'
  get :carnival_float, to: 'pages#carnival_float', as: :carnival_float, path: 'wagenbau'

  resource :contact, only: :create, path: 'kontakt'
  get 'kontakt', to: 'contacts#new', as: :new_contact

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :users do
    get :edit_login, to: 'users#edit_login', path: 'profil/login'
    patch :update_login, to: 'users#update_login', path: 'profil/login'
    delete 'profil/:provider' => 'users#remove_oauth', as: :delete_oauth
  end

  resources :news, only: %i(index show), path: 'news' do
    resources :comments, except: %i(new index show)
  end
  get 'news(/kategorie/:category)(/seite/:page)', to: 'news#index', as: :categorized_news

  resource :user, only: %i(show edit update), path: 'profil'

  resources :galleries, only: %i(index show), path: 'galerie'
  get 'galerie/:gallery_id/bild/:id(/:style)' => 'pictures#show', as: :picture, defaults: { style: :original }

  resources :events, path: 'termine', only: %i(index show) do
    resource :event_participation, path: 'teilnahme', only: %i(create update)
  end

  namespace :admin do
    root to: 'pages#index'

    resources :news, except: :show do
      member do
        put 'publish', format: :js
        put 'unpublish', format: :js
      end
    end

    resources :comments, only: %i(index destroy) do
      member do
        put 'activate'
        put 'deactivate'
      end
    end

    get 'news(/kategorie/:category)(/seite/:page)', to: 'news#index', as: :categorized_news

    resources :users, except: :show
    resources :galleries, except: :show do
      collection do
        put 'sort'
      end
      resources :pictures, except: :show do
        collection do
          put 'sort'
        end
        member do
          put :publish
          put :unpublish
        end
      end
    end

    resources :categories, except: :show
    resources :events
  end

  match '*path', to: 'application#render_404', via: :all
end
