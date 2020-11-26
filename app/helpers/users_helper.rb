module UsersHelper

	include AdminHelper

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


	def is_first_pair_valid id = nil, requested_user_id = nil
		user = User.find(id) if id.present?
		requested_user = User.find_by(id: requested_user_id) if requested_user_id.present?
		left_users = find_left_team(user, true)
		right_users = find_right_team(user, true) 
		if user.present?
			check_main_pair = User.where(sponsered_by_id: user.id).pluck(:position).uniq.count 
			if check_main_pair.present?
				if check_main_pair == 2
					if left_users.present? && right_users.present? 
						if left_users.count >= 2 && right_users.count >= 1
							user.is_first_pair_valid = true
							user.save(validate: false)

						elsif right_users.count >= 2 && left_users.count >= 1 
							user.is_first_pair_valid = true
							user.save(validate: false)
						end
					end
				end
			end
		end
		return requested_user_id
	end




	def get_parent_id id, position
		sql = "WITH RECURSIVE child_users(id, sponsered_by_id,h_parent,position,lvl) AS " +
			"( SELECT id, sponsered_by_id, h_parent, position, 0 FROM users " +
			"WHERE users.id = #{id} " +
			"UNION ALL SELECT  users.id, users.sponsered_by_id, users.h_parent,users.position,child_users.lvl+1 FROM users JOIN child_users " +
			"ON child_users.id = users.h_parent and users.position = '#{position}') " +
			"SELECT id, sponsered_by_id, h_parent,lvl FROM child_users where position ='#{position}'; "
		records_array = ActiveRecord::Base.connection.execute(sql).to_a
		if records_array.present?
			return records_array.last["id"]
		else
			return id
		end
	end


	def get_users id, position
		sql = "WITH RECURSIVE child_users(id, sponsered_by_id,h_parent,position,lvl) AS " +
			"( SELECT id, sponsered_by_id, h_parent, position, 0 FROM users " +
			"WHERE users.id = #{id} " +
			"UNION ALL SELECT  users.id, users.sponsered_by_id, users.h_parent,users.position,child_users.lvl+1 FROM users JOIN child_users " +
			"ON child_users.id = users.h_parent and users.position = '#{position}') " +
			"SELECT id, sponsered_by_id, h_parent,lvl FROM child_users where position ='#{position}'; "
		records_array = ActiveRecord::Base.connection.execute(sql).to_a
		if records_array.present?
			return records_array

			#return records_array.last["id"]
		else
			#return id
		end

	end

	def format_user_details user
		{
			name: user.try(:name) || "",
			user_id: user.try(:sponser_id) || "", 
			sponser_name: User.find_by(id: user.sponsered_by_id).try(:name) || "" ,
			sponser_id: User.find_by(id: user.sponsered_by_id).try(:sponser_id) || "" ,
			left_users: find_left_team(user) || 0 ,
			right_users: find_right_team(user) || 0 ,
			total_team: get_final_users(user).count || 0,
			is_active: user.try(:is_invoice_valid) == true ? "Active" : "Inactive",
			joining_date: user.created_at.strftime("%F")
		}
	end


 end
