class WelcomeController < ApplicationController

	skip_before_action :authenticate_user!, only: [ :index ]

	def index
		@user = User.new
		@url = user_registration_path 
		@saved_user = User.find(params[:user_id]) if params[:user_id].present?
		params[:user_id] = params.except[:user_id] if params[:user_id].present?
	end

	
	def new
	  respond_to do |format|
	    format.html
	    format.js
	  end
	end

	def show
	end


end
