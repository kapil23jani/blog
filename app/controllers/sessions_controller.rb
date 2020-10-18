#this controller is for maintaining session


class SessionsController < ApplicationController
    skip_before_action :authenticate_user!, only: [ :create ]


    #this method is establishing the session

    def new
        @url = user_session_path
    end

    def create
        @user = User.find_by(email: params[:User][:email].downcase)
        if @user.present? 
            if @user.valid_password?(params[:User][:password])
                session[:user_id] = @user.id
                if !@user.admin?
                    redirect_to dashboard_index_path
                else
                    redirect_to admin_index_path
                end

            end
        else
        end
    end


    #this method is user for destroy the session
    def destroy
        if @current_user.present?
            @current_user.authentication_token = nil
            # if @current_user.save
                redirect_to welcome_index_path
            # end
        else
            #render_error("not_found", "#{I18n.t 'Password_create_failed'}")
        end
    end
end








