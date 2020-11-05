module DashboardHelper

	def get_final_users user
		@user = user
		result = []
			users = User.find_by_sql(
		  					"WITH RECURSIVE r AS (
		     				#{User.where(id: user.id).to_sql}
		    				UNION ALL
		     				#{User.joins('JOIN r').where('r.id = users.sponsered_by_id').to_sql})
		   					SELECT * FROM r")
			result << users
			if users.present?
				if @user.position == "Left"
					if users.select {|user| user.position == "Left" }.present?
						users.each do |user|
							parent_users = User.find_by_sql(
										  					"WITH RECURSIVE r AS (
										     				#{User.where(id: user.sponsered_by_id, position: "Left").to_sql}
										    				UNION ALL
										     				#{User.joins('JOIN r').where('r.id = users.sponsered_by_id').to_sql})
										   					SELECT * FROM r")
							if parent_users.present?
								c = parent_users.select { |c_user| c_user.position == "Left" && c_user.created_at > @user.created_at }
								result << c
							end
						end
					end
				else
					# users.each do |user|
					# 	parent_users = User.find_by_sql(
					# 				  					"WITH RECURSIVE r AS (
					# 				     				#{User.where(id: user.sponsered_by_id, position: "right").to_sql}
					# 				    				UNION ALL
					# 				     				#{User.joins('JOIN r').where('r.id = users.sponsered_by_id').to_sql})
					# 				   					SELECT * FROM r")
					# 	if parent_users.present?
					# 		c = parent_users.select { |c_user| c_user.position == "Left" && c_user.created_at > @user.created_at }
					# 		result << c
					# 	end
					# end
				end
			end
		result.flatten.delete_if { |user| user.id == @user.id}

	end

	def all_children(children_array = [])
      children = User.where(sponsered_by_id: user.id)
      children_array += children
      children.each do |child|
        all_children(User.where(sponsered_by_id: child.id))
      end
      children_array
    end
end
