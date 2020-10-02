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
                #@token =JWT.encode({user_id: @user.id, exp: (Time.now + 2.weeks).to_i}, Rails.env.eql?('staging') ? Rails.application.credentials[:secret_key_base] : Rails.application.credentials[:secret_key_base], 'HS256')
                #@user.update(authentication_token: @token)
                session[:user_id] = @user.id
                redirect_to dashboard_index_path

            end
        else
            render 'new'
        end
    end


    #this method is user for destroy the session
    def destroy
        if @current_user.present?
            @current_user.authentication_token = nil
            if @current_user.save
                redirect_to welcome_index_path
            end
        else
            #render_error("not_found", "#{I18n.t 'Password_create_failed'}")
        end
    end
end








