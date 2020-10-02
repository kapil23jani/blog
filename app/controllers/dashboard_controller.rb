class DashboardController < ApplicationController

	def index
		
	end

	def my_teams
		@teams = []
		@teams << @current_user.pairs.pluck(:left_user_id) if @current_user.pairs.present? 
		@teams << @current_user.pairs.pluck(:right_user_id) if @current_user.pairs.present? 
		@final_object = @teams.flatten.compact
 	end

	def my_profile
	end

	def graph
	end
end
