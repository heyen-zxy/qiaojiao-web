Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admins', as: 'rails_admin'
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
}
  root to: 'admin/orders#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    root to: 'orders#index'
    resources :orders
    resources :users
    resources :products
    resources :in_payments
    resources :out_payments
    resources :attachments
  end
end
