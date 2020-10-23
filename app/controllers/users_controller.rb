class UsersController < ApplicationController

	skip_before_action :authenticate_user!, only: [ :fetch_sponser]

	def show

	end

	def edit
		@user = params[:id].present? ? User.find_by(id: params[:id]) : @current_user
	end

	def update
		@user = params[:id].present? ? User.find_by(id: params[:id]) : @current_user
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

	def fetch_sponser
		user = User.find_by(sponser_id: params[:sponser_id])
		if user.present?
			render json: {
            responseCode: 200,
            responseMessage: "Sponser Name: #{user.name}",
        }
		else
			render_error(400, "Sponser not found")
		end
	end

	


	def destroy
		user = User.find_by(id: params[:id])
		user.invoice.destroy
		if user.delete
			redirect_to manage_members_admin_index_path
		else
		end
	end
	

	private

    def user_params
        params.require(:user).permit(:invoice_number, :zipcode, :city, :state, :country, :name, :dob, :sponser_id, :position, :address, :country_code, :phone_number, :pan_number, :gender, :email, :password, :password_confirmation)
    end
end
