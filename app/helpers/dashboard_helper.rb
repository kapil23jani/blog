module DashboardHelper

	def get_final_users user
		@user = user
		if user.present?
			result = []
			users = []
			parent_users = []

			sql = " WITH RECURSIVE r AS ( "+ 
				"SELECT * FROM users WHERE users.id = #{user.id} AND users.position = 'Left' "+
				"UNION "+ 
				"SELECT users.* FROM users JOIN r WHERE r.id = users.sponsered_by_id) "+
				"SELECT * FROM r"
				records_array = ActiveRecord::Base.connection.execute(sql)
				if records_array.present?
					users << User.where(id: records_array.pluck("id"))
				end
				users = users.flatten
				
				result << users
				if users.present?
					if @user.position == "Left" && User.find_by(id: @user.sponsered_by_id).try(:position) == "Left"
						if users.select {|user| user.position == "Left" }.present?
							users.each do |user|
								sql = " WITH RECURSIVE r AS ( "+ 
																				"SELECT * FROM users WHERE users.id = #{user.sponsered_by_id} AND users.position = 'Left' "+
																				"UNION "+ 
																				"SELECT users.* FROM users JOIN r WHERE r.id = users.sponsered_by_id) "+
																				"SELECT * FROM r"
								records_array = ActiveRecord::Base.connection.execute(sql)
								if records_array.present?
									parent_users << User.where(id: records_array.pluck("id"))
								end
								parent_users = parent_users.flatten
								if parent_users.present?
									c = parent_users.select { |c_user| c_user.position == "Left" && c_user.created_at > @user.created_at }
									result << c
								end
							end
						end
					else
						users.each do |user|
							sql = " WITH RECURSIVE r AS ( "+ 
																				"SELECT * FROM users WHERE users.id = #{user.sponsered_by_id} AND users.position = 'Right' "+
																				"UNION "+ 
																				"SELECT users.* FROM users JOIN r WHERE r.id = users.sponsered_by_id) "+
																				"SELECT * FROM r"
								records_array = ActiveRecord::Base.connection.execute(sql)
								if records_array.present?
									parent_users << User.where(id: records_array.pluck("id"))
								end
								parent_users = parent_users.flatten
								if parent_users.present?
									c = parent_users.select { |c_user| c_user.position == "Left" && c_user.created_at > @user.created_at }
									result << c
								end
						end
					end
				end
			result.flatten.delete_if { |user| user.id == @user.id}
		end

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
