=begin
    Original Author: Kapil Jani
    Development Group: SOI
    Description: This controller contains common methods for signing up user, update user profile
=end
class RegistrationsController < ApplicationController

    include UsersHelper

    skip_before_action :authenticate_user!, only: [ :new, :create ]

	def new
		@user = User.new
		@url = user_registration_path
	end

    def create
    	@user = User.new(user_params)
        @user.sponser_id = 8.times.map { [*'0'..'9', *'a'..'z'].sample }.join.upcase
        @user.dob = params[:date].present? ? fetch_date_of_birth : ""
    	if @user.save 
            @sponser_user = User.find_by(sponser_id: params[:sponser_id])
            if params[:position] == "Left"
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
            elsif params[:position] == "Right"
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
    		session[:user_id] = @user.id
    		redirect_to welcome_index_path
    	else
            render_error(400, @user.errors.full_messages.join(','))
    	end
    end

    private

    def user_params
        params.permit(:zipcode, :city, :state, :country, :name, :dob, :sponser_id, :position, :address, :country_code, :phone_number, :pan_number, :gender, :email, :password, :password_confirmation)
    end
end
