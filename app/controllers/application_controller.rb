class ApplicationController < ActionController::Base
	before_action :authenticate_user!
    
    def authenticate_user!
        @current_user = User.find_by(id: session[:user_id])
        if !@current_user.present?            
            redirect_to welcome_index_path
        end
    end
end
