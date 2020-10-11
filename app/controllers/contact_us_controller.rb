class ContactUsController < ApplicationController

	def new
		@contact_us = Contact.new
	end

	def create
		@contact_us = Contact.new(contact_us_params)
		if @contact_us.save
			redirect_to welcome_index_path
		else
			render 'new'
		end
	end

	private

	def contact_us_params
		 params.require(:contact_us).permit(:first_name, :last_name, :email, :subject, :message)
	end

end
