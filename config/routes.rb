Rails.application.routes.draw do

  # devise_for :users

  root to: "welcome#index"


	resources :dashboard do 
    get :my_teams, on: :collection  
  end
	resources :welcome

	devise_for :users, controllers: {
                    registrations: "registrations",
                    passwords: "passwords",
                    sessions: "sessions",
                    confirmations: "confirmations"
                }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
