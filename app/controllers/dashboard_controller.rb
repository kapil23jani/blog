class DashboardController < ApplicationController

	def index
	end

	def my_teams
		user = params[:user_id].present? ? User.find_by(id: params[:user_id]) : @current_user
		@teams = []
		@teams << user.pairs.pluck(:left_user_id) if user.pairs.present? 
		@teams << user.pairs.pluck(:right_user_id) if user.pairs.present? 
		@final_object = @teams.flatten.compact
		data = {}
		users_where = "(lower(users.name) LIKE :search) OR (lower(users.position) LIKE :search) OR (lower(users.phone_number) LIKE :search)"
	    users_where_values = {}
	    search = params[:search].to_s.downcase if params[:search].present?
	    users_where_values.merge!(search: "%#{search}%")  
	    if params[:start_date].present? && params[:end_time].present?
		    @users = User.where(id: @final_object).where([users_where, users_where_values]).where('created_at BETWEEN ? AND ?', params[:start_date], params[:end_time])
		else
			@users = User.where(id: @final_object).where([users_where, users_where_values])
		end

	    session[:search] = {}
	 end

	def my_profile
	end

	def graph
	end

	def invoice
	end
end
