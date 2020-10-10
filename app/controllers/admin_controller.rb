class AdminController < ApplicationController

	def index
	end

	def members
		data = {}
		users_where = "(lower(users.name) LIKE :search) OR (lower(users.position) LIKE :search) OR (lower(users.phone_number) LIKE :search)"
	    users_where_values = {}
	    search = params[:search].to_s.downcase if params[:search].present?
	    users_where_values.merge!(search: "%#{search}%")  
	    if params[:start_date].present? && params[:end_time].present?
		    @users = User.where([users_where, users_where_values]).where('created_at BETWEEN ? AND ?', params[:start_date], params[:end_time])
		else
			@users = User.where([users_where, users_where_values])
		end

	    session[:search] = {}
	end

	def manage_members
	end
end
