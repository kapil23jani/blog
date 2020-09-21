class UsersController < ApplicationController

	def show

	end

	def edit
	end

	def update
		@user = @current_user
		@user.update_attributes(user_params)
		if @user.save
			redirect_to my_profile_dashboard_index_path
		else
			render 'edit'
		end
	end

	# def destroy
	# end

	private

    def user_params
        params.require(:user).permit(:zipcode, :city, :state, :country, :name, :dob, :sponser_id, :position, :address, :country_code, :phone_number, :pan_number, :gender, :email, :password, :password_confirmation)
    end
end
