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
        @user.sponsered_by_id = User.find_by(sponser_id: params[:sponser_id]).try(:id)  if params[:sponser_id].present?
        return render_error(400, "Sponser Not Found") if @user.sponsered_by_id.nil?
        @user.h_parent = get_parent_id(User.find_by(sponser_id: params[:sponser_id]).try(:id), params[:position]) if @user.sponsered_by_id.present?
        @user.dob = params[:date].present? ? fetch_date_of_birth : ""
        @user.sponser_id = params[:unique_user_id].present? ? params[:unique_user_id] : nil
        @user.is_invoice_valid = false
        @user.unique_user_id = params[:password]
    	if @user.save(validate: false)
            render_message("Registered Successfully", @user)
    	else
            render_error(400, @user.errors.full_messages.join(','))
    	end
    end

    private

    def user_params
        params.permit(:zipcode, :city, :state, :country, :name, :dob, :position, :address, :country_code, :phone_number, :pan_number, :gender, :email, :password, :password_confirmation)
    end
end
