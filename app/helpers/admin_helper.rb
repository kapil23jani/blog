module AdminHelper

	include DashboardHelper

	def get_active_users user, type = nil
		if !user.admin?
			if type == "active_left"
				left_users = get_users(user.id, "Left").present? ?  get_users(user.id, "Left").pluck("id") : nil
				child_left_users = User.where(sponsered_by_id: get_users(user.id, "Left").pluck("id")).pluck(:id) if left_users.present?
				
				left_users << child_left_users if child_left_users.present?
				left_users = User.where(id: left_users.flatten.uniq, is_invoice_valid: true) if left_users.present?
				return left_users.try(:count)
			elsif type == "active_right"
				users = []
				right_users = get_users(user.id, "Right").present? ?  get_users(user.id, "Right").pluck("id") : nil
				child_right_users = User.where(sponsered_by_id: get_users(user.id, "Right").pluck("id")).pluck(:id) if right_users.present?
				
				right_users << child_right_users if child_right_users.present?
				right_users = User.where(id: right_users.flatten.uniq, is_invoice_valid: true) if right_users.present?
				return right_users.try(:count)
			end
		end
	end


	def find_left_team user
		if !user.admin?
			users = []
			left_users = User.where(h_parent: user.id, position: "Left").pluck(:id)
			child_left_users = get_final_users(User.find left_users[0]).pluck(:id) if left_users.present?
			left_users << child_left_users if child_left_users.present?
			left_users = User.where(id: left_users.flatten.uniq) if left_users.present?
			return left_users.try(:count)
		end
	end

	def find_right_team user
		if !user.admin?
			right_users = User.where(h_parent: user.id, position: "Right").pluck(:id)
			child_right_users = get_final_users(User.find right_users[0]).pluck(:id) if right_users.present?
			right_users << child_right_users if child_right_users.present?
			right_users = User.where(id: right_users.flatten.uniq) if right_users.present?
			return right_users.try(:count)
		end
	end



	def find_pair user, type = nil 
		if !user.admin?
			check_main_pair = User.where(sponsered_by_id: user.id).pluck(:position).uniq.count
			return 0 if check_main_pair == 1 || check_main_pair == 0
			users = []
			left_users = get_users(user.id, "Left").pluck("id")
			right_users = get_users(user.id, "Right").pluck("id")
			child_left_users = get_final_users(User.find left_users[0]).pluck(:id) if left_users.present?
			child_right_users = get_final_users(User.find right_users[0]).pluck(:id) if right_users.present?
			
			left_users << child_left_users if child_left_users.present?
			right_users << child_right_users if child_right_users.present?
			left_users = User.where(id: left_users.flatten.uniq) if left_users.present?
			right_users = User.where(id: right_users.flatten.uniq) if right_users.present?

			if type == 1
				left_final_pairs = left_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime, (Date.today.beginning_of_month).to_datetime + 10.days).sort
				right_final_pairs = right_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime, (Date.today.beginning_of_month).to_datetime + 10.days).sort
				return calculate_pairs(left_final_pairs, right_final_pairs)
			elsif type == 2
				left_final_pairs = left_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 10.days, (Date.today.beginning_of_month).to_datetime + 20.days).sort
				right_final_pairs = right_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 10.days, (Date.today.beginning_of_month).to_datetime + 20.days).sort
				return calculate_pairs(left_final_pairs, right_final_pairs)
			elsif type == 3
				left_final_pairs = left_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 20.days, (Date.today.beginning_of_month).to_datetime + 30.days).sort
				right_final_pairs = right_users.where('created_at BETWEEN ? AND ?', (Date.today.beginning_of_month).to_datetime + 20.days, (Date.today.beginning_of_month).to_datetime + 30.days).sort
				return calculate_pairs(left_final_pairs, right_final_pairs)
			elsif type == 4
				return calculate_pairs(left_users, right_users)
			end
		end
	end

	def calculate_pairs left_final_pairs = nil, right_final_pairs = nil

		if left_final_pairs.present? && right_final_pairs.present?
			if left_final_pairs.count == right_final_pairs.count
				return left_final_pairs.count - 1 
			elsif left_final_pairs.count > right_final_pairs.count
				return right_final_pairs.count
			elsif right_final_pairs.count > left_final_pairs.count
				return left_final_pairs.count
			else
				return 0
			end
		else
			return 0
		end
	end

				
				
				


end
