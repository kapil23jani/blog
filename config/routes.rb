Rails.application.routes.draw do

  # devise_for :users

  root to: "welcome#index"


	resources :dashboard do 
    get :my_teams, on: :collection  
    get :my_profile, on: :collection  
    get :graph, on: :collection  
  end
	resources :welcome

	devise_for :users, controllers: {
                    registrations: "registrations",
                    passwords: "passwords",
                    sessions: "sessions",
                    confirmations: "confirmations"
                }
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
