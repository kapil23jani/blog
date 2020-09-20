class WelcomeController < ApplicationController

	skip_before_action :authenticate_user!, only: [ :index ]

	def index
		@user = User.new
		@url = user_registration_path
	end

	
	def new
	  respond_to do |format|
	    format.html
	    format.js
	  end
	end

end
