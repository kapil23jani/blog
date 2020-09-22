class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	skip_before_action :verify_authenticity_token
	protect_from_forgery prepend: true, with: :null_session
    
    def authenticate_user!
        @current_user = User.find_by(id: session[:user_id])
        if !@current_user.present?            
            redirect_to welcome_index_path
        end
    end
end
