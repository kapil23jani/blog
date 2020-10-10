Rails.application.routes.draw do

  # devise_for :users

  root to: "welcome#index"


	resources :dashboard do 
    get :my_teams, on: :collection  
    get :my_profile, on: :collection  
    get :graph, on: :collection  
  end
	resources :welcome
  resources :admin do 
    get :members, on: :collection
    get :manage_members, on: :collection
  end

	devise_for :users, controllers: {
                    registrations: "registrations",
                    passwords: "passwords",
                    sessions: "sessions",
                    confirmations: "confirmations"
                }
  resources :users do 
    get :get_user_kyc, on: :collection  
    put :update_user_kyc, on: :collection  
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
