=begin
    Original Author: Kapil Jani
    Development Group: SOI
    Description: This controller contains common methods for signing up user, update user profile
=end
class RegistrationsController < ApplicationController

	def new
		@user = User.new
		@url = user_registration_path
	end

    def create

       
    end

    private

    def user_params
        params.permit(:email, :password, :password_confirmation)
    end
end
