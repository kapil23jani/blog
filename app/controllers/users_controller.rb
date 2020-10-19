class UsersController < ApplicationController

	def show

	end

	def edit
		@user = params[:id].present? ? User.find_by(id: params[:id]) : @current_user
	end

	def update
		@user = params[:id].present? ? User.find_by(id: params[:id]) : @current_user
		binding.pry
		@user.role_id = Role.find_by(role_type: "super_user").id if params[:role_type].present?
		@user.update_attributes(user_params)
		if @user.save(validate: false)
			if @current_user.admin?
				redirect_to manage_members_admin_index_path 
			else
				redirect_to my_profile_dashboard_index_path
			end
		else
			render 'edit'
		end
	end

	def get_user_kyc
	end

	def update_user_kyc
	end

	


	def destroy
		user = User.find_by(id: params[:id])
		if user.destroy
			redirect_to manage_members_admin_index_path
		else
		end
	end
	

	private

    def user_params
        params.require(:user).permit(:invoice_number, :zipcode, :city, :state, :country, :name, :dob, :sponser_id, :position, :address, :country_code, :phone_number, :pan_number, :gender, :email, :password, :password_confirmation)
    end
end
