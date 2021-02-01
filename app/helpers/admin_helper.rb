module AdminHelper

	include DashboardHelper

	def get_active_users user, type = nil
		if !user.admin?
			if type == "active_left"
				left_users = find_left_team(user, true).present? ?  find_left_team(user, true) : nil
				left_users = left_users.where(is_invoice_valid: true) if left_users.present?
				return left_users.try(:count) || 0
			elsif type == "active_right"
				users = []
				right_users = find_right_team(user, true).present? ?  find_right_team(user, true) : nil
				right_users = right_users.where(is_invoice_valid: true) if right_users.present?
				return right_users.try(:count) || 0
			end
		end
	end


	def find_left_team user, is_pair_request = nil
		if !user.admin?
			users = []
			left_users = User.where(h_parent: user.id, position: "Left").pluck(:id)
			child_left_users = get_final_users(User.find left_users[0]).pluck(:id) if left_users.present?
			left_users << child_left_users if child_left_users.present?
			left_users = User.where(id: left_users.flatten.uniq) if left_users.present?
			return left_users.try(:count) || 0 if is_pair_request.nil?
			left_users || nil
		end
	end

	def find_right_team user, is_pair_request = nil
		if !user.admin?
			right_users = User.where(h_parent: user.id, position: "Right").pluck(:id)
			child_right_users = get_final_users(User.find right_users[0]).pluck(:id) if right_users.present?
			right_users << child_right_users if child_right_users.present?
			right_users = User.where(id: right_users.flatten.uniq) if right_users.present?
			return right_users.try(:count) || 0 if is_pair_request.nil?
			right_users || nil
		end
	end

	def find_left_inactive_team user
		if !user.admin?
			users = []
			left_users = User.where(h_parent: user.id, position: "Left").pluck(:id)
			child_left_users = get_final_users(User.find left_users[0]).pluck(:id) if left_users.present?
			left_users << child_left_users if child_left_users.present?
			left_users = User.where(id: left_users.flatten.uniq) if left_users.present?
			return left_users.present? ? left_users.where(is_invoice_valid: false).count : 0
		end
	end

	def find_right_inactive_team user, is_pair_request = nil
		if !user.admin?
			right_users = User.where(h_parent: user.id, position: "Right").pluck(:id)
			child_right_users = get_final_users(User.find right_users[0]).pluck(:id) if right_users.present?
			right_users << child_right_users if child_right_users.present?
			right_users = User.where(id: right_users.flatten.uniq) if right_users.present?
			return right_users.present? ? right_users.where(is_invoice_valid: false).count : 0
		end
	end



	def left_fetch_pending_pair user, type = nil, duration = nil
		if !user.admin?
			check_main_pair = User.where(sponsered_by_id: user.id).pluck(:position).uniq.count
			return 0 if check_main_pair == 1 || check_main_pair == 0 
			users = find_left_team(user, true).present? ? find_left_team(user, true).where(is_invoice_valid: true) : nil if type = "Left"
			if duration == 1
				final_pairs = users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime, (Date.today.beginning_of_month).to_datetime + 7.days).sort if users.present?
				return final_pairs.count if final_pairs.present?
				return 0
			elsif duration == 2
				final_pairs = users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 7.days, (Date.today.beginning_of_month).to_datetime + 14.days).sort if users.present?
				return final_pairs.count if final_pairs.present?
				return 0
			elsif duration == 3
				final_pairs = users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 14.days, (Date.today.beginning_of_month).to_datetime + 21.days).sort if users.present?
				return final_pairs.count if final_pairs.present?
				return 0
			elsif duration == 6
				final_pairs = users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 21.days, (Date.today.beginning_of_month).to_datetime + 28.days).sort if users.present?
				return final_pairs.count if final_pairs.present?
				return 0
			elsif duration == 7
				final_pairs = users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 28.days, (Date.today.beginning_of_month).to_datetime + find_end_of_month.days).sort if users.present?
				return final_pairs.count if final_pairs.present?
				return 0
			end
		end
	end

	def right_fetch_pending_pair user, type = nil, duration = nil
		if !user.admin?
			check_main_pair = User.where(sponsered_by_id: user.id).pluck(:position).uniq.count
			return 0 if check_main_pair == 1 || check_main_pair == 0 
			users = find_right_team(user, true).present? ? find_right_team(user, true).where(is_invoice_valid: true) : nil if type = "Right"
			if duration == 1
				final_pairs = users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime, (Date.today.beginning_of_month).to_datetime + 7.days).sort if users.present?
				return final_pairs.count if final_pairs.present?
				return 0
			elsif duration == 2
				final_pairs = users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 7.days, (Date.today.beginning_of_month).to_datetime + 14.days).sort if users.present?
				return final_pairs.count if final_pairs.present?
				return 0
			elsif duration == 3
				final_pairs = users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 14.days, (Date.today.beginning_of_month).to_datetime + 21.days).sort if users.present?
				return final_pairs.count if final_pairs.present?
				return 0
			elsif duration == 6
				final_pairs = users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 21.days, (Date.today.beginning_of_month).to_datetime + 28.days).sort if users.present?
				return final_pairs.count if final_pairs.present?
				return 0
			elsif duration == 7
				final_pairs = users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 28.days, (Date.today.beginning_of_month).to_datetime + find_end_of_month.days).sort if users.present?
				return final_pairs.count if final_pairs.present?
				return 0
			end
		end
	end

	def find_pair user, type = nil , last_closing = false
		if !user.admin?
			check_main_pair = User.where(sponsered_by_id: user.id).pluck(:position).uniq.count
			return 0 if check_main_pair == 1 || check_main_pair == 0
			left_users = find_left_team(user, true).present? ? find_left_team(user, true).where(is_invoice_valid: true) : nil
			right_users = find_right_team(user, true).present? ? find_right_team(user, true).where(is_invoice_valid: true) : nil

			if type == 1
				left_final_pairs = left_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime, (Date.today.beginning_of_month).to_datetime + 7.days).sort if left_users.present?
				right_final_pairs = right_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime, (Date.today.beginning_of_month).to_datetime + 7.days).sort if right_users.present?
				if left_final_pairs.present? && right_final_pairs.present?
					return calculate_pairs(left_final_pairs, right_final_pairs, user) if last_closing == true
					return calculate_pairs(left_final_pairs, right_final_pairs, user) if Date.today.strftime("%d").to_i <= 7
					return 0 
				else
					return 0
				end
			elsif type == 2
				left_final_pairs = left_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 7.days, (Date.today.beginning_of_month).to_datetime + 14.days).sort if left_users.present?
				right_final_pairs = right_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 7.days, (Date.today.beginning_of_month).to_datetime + 14.days).sort if right_users.present?
				if left_final_pairs.present? && right_final_pairs.present?		

					return calculate_pairs(left_final_pairs, right_final_pairs, user) if last_closing == true
					return calculate_pairs(left_final_pairs, right_final_pairs, user) if Date.today.strftime("%d").to_i <= 14
					return 0
				else
					return 0
				end
			elsif type == 3
				left_final_pairs = left_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 14.days, (Date.today.beginning_of_month).to_datetime + 21.days).sort if left_users.present?
				right_final_pairs = right_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 14.days, (Date.today.beginning_of_month).to_datetime + 21.days).sort if right_users.present?
				if left_final_pairs.present? && right_final_pairs.present?					
					return calculate_pairs(left_final_pairs, right_final_pairs, user) if last_closing == true
					return calculate_pairs(left_final_pairs, right_final_pairs, user) if Date.today.strftime("%d").to_i <= 21
					return 0
				else
					return 0
				end
			elsif type == 6
				left_final_pairs = left_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 21.days, (Date.today.beginning_of_month).to_datetime + 28.days).sort if left_users.present?
				right_final_pairs = right_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 21.days, (Date.today.beginning_of_month).to_datetime + 28.days).sort if right_users.present?
				if left_final_pairs.present? && right_final_pairs.present?					
					return calculate_pairs(left_final_pairs, right_final_pairs, user) if last_closing == true
					return calculate_pairs(left_final_pairs, right_final_pairs, user) if Date.today.strftime("%d").to_i <= 28
					return 0
				else
					return 0
				end
			elsif type == 7
				left_final_pairs = left_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 28.days, (Date.today.beginning_of_month).to_datetime + find_end_of_month.days).sort if left_users.present?
				right_final_pairs = right_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 28.days, (Date.today.beginning_of_month).to_datetime + find_end_of_month.days).sort if right_users.present?
				if left_final_pairs.present? && right_final_pairs.present?					
					return calculate_pairs(left_final_pairs, right_final_pairs, user) if last_closing == true
					return calculate_pairs(left_final_pairs, right_final_pairs, user)
				else
					return 0
				end
			elsif type == 5
				left_final_pairs = left_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime, (Date.today.end_of_month).to_datetime).sort if left_users.present?
				right_final_pairs = right_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime, (Date.today.end_of_month).to_datetime).sort if right_users.present?
				return calculate_pairs(left_final_pairs, right_final_pairs, user)
			elsif type == 4
				if left_final_pairs.present? && right_final_pairs.present?					
					return calculate_pairs(left_final_pairs, right_final_pairs, user)
				else
					return 0
				end
			elsif type == 10
				if left_users.present? && right_users.present?				
					return calculate_pairs(left_users, right_users, user, true)
				else
					return 0
				end
			end
		end
	end


	def find_end_of_month 
		if Date.today.end_of_month.strftime("%d").to_i == 30
			return 30
		elsif Date.today.end_of_month.strftime("%d").to_i == 31
			return 31
		elsif Date.today.end_of_month.strftime("%d").to_i == 29
			return 29
		elsif Date.today.end_of_month.strftime("%d").to_i == 28
			return 28
		else
		end
	end


	def calculate_pairs left_final_pairs = 0, right_final_pairs = 0, user = nil, is_first_pair = false
		if is_first_pair == true
			if left_final_pairs.count >= 2 && right_final_pairs.count <= 2 || right_final_pairs.count >= 2 && left_final_pairs.count <= 2
				return "Yes"
			else
				return "No"
			end
		else
			if left_final_pairs.count == right_final_pairs.count
				return user.try(:is_first_pair_valid) == true ? left_final_pairs.count : left_final_pairs.count - 1
			elsif left_final_pairs.count > right_final_pairs.count
				return right_final_pairs.count
			elsif right_final_pairs.count > left_final_pairs.count
				return left_final_pairs.count
			else
				return 0
			end
		end
		
	end

	def top_joines last_closing = false
		users = User.all
		result = []
		date = Date.today.strftime("%d").to_i
		if last_closing == true
			if date == 8 || date == 9 || date == 10
				duration = 1
			elsif date == 15 || date == 16 || date == 17
				duration = 2
			elsif date == 22 || date == 23 || date == 24
				duration = 3
			elsif date == 29 || date == 30 || date == 31
				duration = 6
			elsif date == 1 || date == 2 || date == 3
				duration = 7 
			end
			users.each_with_index do |user, i|
				if !user.admin?
					result << {
						name: user.try(:name) || "",
						user_id: user.try(:sponser_id) || "",
						sponser_name: User.find_by(id: user.sponsered_by_id).try(:name) || "",
						sponser_id: User.find_by(id: user.sponsered_by_id).try(:sponser_id) || "",
						pairs: find_pair(user, duration, true) || 0,
						is_invoice_valid: user.try(:is_invoice_valid),
						phone_pe: user.try(:upi_id),
						is_first_pair: find_pair(user, 10, true) || "No"

					}
				end
			end
			result = result.delete_if {|x| x[:pairs].to_i == 0}
			return result.sort_by {|x| p x[:pairs]}.reverse.first(20) if result.present?
		else
			duration = (1..7).include?(date) ? 1 : (8..14).include?(date) ? 2 : (15..21).include?(date) ? 3 : (22..28).include?(date) ? 6 : (29..31).include?(date) ? 7 : nil
			users.each_with_index do |user, i|
				if !user.admin?
					result << {
						name: user.try(:name) || "",
						user_id: user.try(:sponser_id) || "",
						sponser_name: User.find_by(id: user.sponsered_by_id).try(:name) || "",
						sponser_id: User.find_by(id: user.sponsered_by_id).try(:sponser_id) || "",
						pairs: find_pair(user, duration) || 0,
						is_invoice_valid: user.try(:is_invoice_valid),
						is_first_pair: find_pair(user, 10, false) || "No"
					}
				end
			end
			result = result.delete_if {|x| x[:pairs].to_i == 0}
			return result.sort_by {|x| p x[:pairs]}.reverse.first(20) if result.present?
		end
	end






				
				
				


end
