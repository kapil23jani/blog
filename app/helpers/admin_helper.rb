module AdminHelper

	include DashboardHelper

	def get_active_users user, type = nil
		if !user.admin?
			users = get_final_users(user)
			if type == "active_left"
				count = users.select {|user| user.position == "Left" && user.is_invoice_valid == true}.count
			elsif type == "active_right"
				count = users.select {|user| user.position == "Right" && user.is_invoice_valid == true}.count
			elsif type == "inactive_left"
				count = users.select {|user| user.position == "Left" && user.is_invoice_valid == false}.count
			elsif type == "inactive_right"
				count = users.select {|user| user.position == "Right" && user.is_invoice_valid == false}.count
			
			end
		end
	end

	def find_pair user, type = nil 
		if !user.admin?
			users = get_final_users(user)
			if type == 1
				check_main_pair = users.select{|child_user| child_user.sponsered_by_id ==  user.id}.pluck(:position).uniq.count
				return 0 if check_main_pair == 1 || check_main_pair == 0
				final_pair = User.where(id: users.pluck(:id)).where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime, (Date.today.beginning_of_month).to_datetime + 10.days).sort
				return calculate_pairs(final_pair)
			elsif type == 2
				check_main_pair = users.select{|child_user| child_user.sponsered_by_id ==  user.id}.pluck(:position).uniq.count
				return 0 if check_main_pair == 1 || check_main_pair == 0
				final_pair = User.where(id: users.pluck(:id)).where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 10.days, (Date.today.beginning_of_month).to_datetime + 20.days).sort
				return calculate_pairs(final_pair)	
			elsif type == 3
				check_main_pair = users.select{|child_user| child_user.sponsered_by_id ==  user.id}.pluck(:position).uniq.count
				return 0 if check_main_pair == 1 || check_main_pair == 0
				final_pair = User.where(id: users.pluck(:id)).where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 20.days, (Date.today.beginning_of_month).to_datetime + 30.days).sort
				return calculate_pairs(final_pair)
			elsif type == 4
				check_main_pair = users.select{|child_user| child_user.sponsered_by_id ==  user.id}.pluck(:position).uniq.count
				return 0 if check_main_pair == 1 || check_main_pair == 0
				final_pair = User.where(id: users.pluck(:id))
				return calculate_pairs(final_pair)
			end
		end
	end

	def calculate_pairs users = nil
		left_users = users.select{|user| user.position == "Left"}
		right_users = users.select{|user| user.position == "Right"}

		if left_users.present? && right_users.present?
			if left_users.count == right_users.count
				return left_users.count - 1 
			elsif left_users.count > right_users.count
				return right_users.count
			elsif right_users.count > left_users.count
				return left_users.count - 1
			else
				return 0
			end
		else
			return 0
		end
	end

				
				
				


end
