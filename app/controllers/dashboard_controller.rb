class DashboardController < ApplicationController

	include DashboardHelper
	include AdminHelper

	def index
	end

	def my_teams
		user = params[:user_id].present? ? User.find_by(id: params[:user_id]) : @current_user
		@teams = []
		@final_object = get_final_users(user)
		data = {}
		users_where = "(lower(users.name) LIKE :search) OR (lower(users.position) LIKE :search) OR (lower(users.phone_number) LIKE :search)"
	    users_where_values = {}
	    search = params[:search].to_s.downcase if params[:search].present?
	    users_where_values.merge!(search: "%#{search}%")  
	    if params[:start_date].present? && params[:end_time].present?
		    @users = User.where(id: @final_object).where([users_where, users_where_values]).where('created_at BETWEEN ? AND ?', params[:start_date], params[:end_time])
		else
			@users = User.where(id: @final_object).where([users_where, users_where_values]).uniq
		end


	    session[:search] = {}
	 end

	def my_profile
	end

	def graph
		@user = params[:graph].present? ? User.find_by(sponser_id: params[:graph][:sponser_id]) : params[:id].nil? ? @current_user : User.find_by(id: params[:id])
		#@graph_data = get_chart_for_users(user)
		#@graph_users = User.where(id: @graph_data.pluck("id")).sort
	end

	def invoice
	end
end
