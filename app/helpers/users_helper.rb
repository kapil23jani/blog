module UsersHelper

	def fetch_date_of_birth
		result = []
		if params[:date].present?
			result << params[:date]
		end
		
		if params[:month].present?
			result << params[:month]
		end

		if params[:year].present?
			result << params[:year]
		end

		return result.join("-")
	end

end
