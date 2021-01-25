Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/rails_admins', as: 'rails_admin'
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
}
  root to: 'admin/products#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin, path: ""  do
    root to: 'orders#index'
    resources :orders
    resources :users
    resources :products
    resources :in_payments
    resources :out_payments
    resources :attachments do
      collection do
        post :upload
        post :upload_file
      end
    end
  end
end
