Rails.application.routes.draw do
  resource :wechat, only: [:show, :create]
  devise_for :users
  mount ApplicationAPI => '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc'
  mount RailsAdmin::Engine => '/rails_admins', as: 'rails_admin'
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }
  root to: 'admin/orders#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin, path: ""  do
    root to: 'orders#index'
    resources :orders do
      member do
        get :server_admins
        post :set_server_admin
        get :get_desc
        post :set_desc
      end
    end

    resource :profile
    resources :users do
      member do
        get :company
        get :admin
        get :qrcode
        post :set_admin
        post :set_company
      end
    end

    resources :products do
      collection do
        post :change_status
        post :tag_options
      end
    end
    resources :in_payments
    resources :out_payments
    resources :banners do
      collection do
        post :change_status
      end
    end
    resources :news do
      collection do
        post :change_status
      end
    end
    resources :attachments do
      collection do
        post :upload
        post :upload_file
      end
    end

    resources :tags
    resources :agents

    resources :admin_commission_logs
    resources :user_commission_logs
    resources :public_messages
    resources :server_users do
      member do
        get :cash_form
        post :cash
        get :agent
        post :set_agent
      end
    end
  end

  mount ChinaCity::Engine => '/china_city'

end
