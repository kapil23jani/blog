Rails.application.routes.draw do

  # devise_for :users

  root to: "welcome#index"


	resources :dashboard do 
    get :my_teams, on: :collection  
    get :my_profile, on: :collection  
    get :graph, on: :collection  
    get :invoice, on: :collection  
  end

  resources :invoices

	resources :welcome do
    get :user_detail, on: :collection
  end
  resources :contact_us
  resources :admin do 
    get :members, on: :collection
    put :assign_super_user, on: :collection  
    get :manage_members, on: :collection
    get :pair_details, on: :collection
    get :contact_us, on: :collection
    get :invoice_operation, on: :collection
    get :invoices, on: :collection
    # patch :assign_admin, on: :collection  
  end

	devise_for :users, controllers: {
                    registrations: "registrations",
                    passwords: "passwords",
                    sessions: "sessions",
                    confirmations: "confirmations"
                }
  resources :users do 
    put :assign_super_user, on: :collection  
    get :get_user_kyc, on: :collection  
    put :update_user_kyc, on: :collection  
    post :fetch_sponser, on: :collection
    put 'set_super_admin', on: :member
    get 'get_user_details', on: :member
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
