=begin
    Original Author: Kapil Jani
    Development Group: SOI
    Description: This controller contains common methods for signing up user, update user profile
=end
class RegistrationsController < ApplicationController

    skip_before_action :authenticate_user!, only: [ :new, :create ]

	def new
		@user = User.new
		@url = user_registration_path
	end

    def create
    	@user = User.new(user_params)
        @user.sponser_id = 8.times.map { [*'0'..'9', *'a'..'z'].sample }.join.upcase
        @user.password = 123456789
    	if @user.save 
            @sponser_user = User.find_by(sponser_id: params[:user][:sponser_id])
            if params[:user][:position] == "Left"
                if @sponser_user.pairs.where(left_user_id: nil).present?
                    pair = @sponser_user.pairs.where(left_user_id: nil).last
                    pair.left_user_id = @user.id
                    pair.user_id = @sponser_user.id
                    pair.save
                else
                    pair = @sponser_user.pairs.new
                    pair.left_user_id = @user.id
                    pair.user_id = @sponser_user.id
                    pair.save
                end
            elsif params[:user][:position] == "Right"
                if @sponser_user.pairs.where(right_user_id: nil).present?
                    pair = @sponser_user.pairs.where(right_user_id: nil).last
                    pair.right_user_id = @user.id
                    pair.user_id = @sponser_user.id
                    pair.save
                else
                    pair = @sponser_user.pairs.new
                    pair.right_user_id = @user.id
                    pair.user_id = @sponser_user.id
                    pair.save
                end
            end
                    
    		#token = JWT.encode({user_id: @user.id, exp: (Time.now + 2.weeks).to_i}, Rails.env.eql?('staging') ? Rails.application.credentials[:secret_key_base] : Rails.application.credentials[:secret_key_base], 'HS256')
    		#@user.update_attributes(authentication_token: @token)
    		session[:user_id] = @user.id
    		redirect_to dashboard_index_path
    	else
    		render 'new'
    	end
    end

    private

    def user_params
        params.require(:user).permit(:zipcode, :city, :state, :country, :name, :dob, :sponser_id, :position, :address, :country_code, :phone_number, :pan_number, :gender, :email, :password, :password_confirmation)
    end
end
