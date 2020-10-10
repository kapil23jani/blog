class DashboardController < ApplicationController

	def index
	end

	def my_teams
		@teams = []
		@teams << @current_user.pairs.pluck(:left_user_id) if @current_user.pairs.present? 
		@teams << @current_user.pairs.pluck(:right_user_id) if @current_user.pairs.present? 
		@final_object = @teams.flatten.compact
		data = {}
		users_where = "(lower(users.name) LIKE :search) OR (lower(users.position) LIKE :search) OR (lower(users.phone_number) LIKE :search)"
	    users_where_values = {}

	    search = params[:user][:search].to_s.downcase if params[:user][:search].present?

	    users_where_values.merge!(search: "%#{search}%")  
	    @users = User.where(id: @final_object).where([users_where, users_where_values])
	 end

	def my_profile
	end

	def graph
	end
end
