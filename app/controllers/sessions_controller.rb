#this controller is for maintaining session


class SessionsController < ApplicationController
    skip_before_action :authenticate_user!, only: [ :create ]


    #this method is establishing the session

    def new
        @url = user_session_path
    end

    def create
        temp_user = User.where(sponser_id: params[:User][:sponser_id].upcase).or(User.where(email: params[:User][:sponser_id]))
        if temp_user.last.present? 
            @user = temp_user.last
            if @user.valid_password?(params[:User][:password])
                session[:user_id] = @user.id
                if !@user.admin?
                    redirect_to dashboard_index_path
                else
                    redirect_to admin_index_path
                end
            else
                flash[:danger] = "Invalid User ID or Password"
                redirect_to welcome_index_path
            end
        else
            flash[:danger] = "Invalid User ID or Password"
            redirect_to welcome_index_path
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








