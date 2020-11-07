module DashboardHelper

	def get_final_users user
		@user = user
		if user.present?
			result = []
			users = []
			@parent_users = []
			sql = " WITH RECURSIVE r AS ( "+ 
				"SELECT * FROM users WHERE users.id = #{user.id} "+
				"UNION ALL "+ 
				"SELECT users.* FROM users JOIN r on (r.id = users.sponsered_by_id)) "+
				"SELECT * FROM r "
			records_array = ActiveRecord::Base.connection.execute(sql).to_a
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
									"UNION ALL "+ 
									"SELECT users.* FROM users JOIN r on (r.id = users.sponsered_by_id)) "+
									"SELECT * FROM r"
							records_array = ActiveRecord::Base.connection.execute(sql).to_a
							if records_array.present?
								if User.where(id: records_array.pluck("id")).present?
									users = User.where(id: records_array.pluck("id")).present? ? User.where(id: records_array.pluck("id")) : []
									@parent_users << users
								end
								@parent_users = @parent_users.try(:flatten)
							end
							if @parent_users.present?
								c = @parent_users.select { |c_user| c_user.try(:position) == "Left" && c_user.created_at > @user.created_at && User.find_by(id: c_user.sponsered_by_id).try(:position) != "Right"}
								result << c
							end
							sql = " WITH RECURSIVE r AS ( "+ 
									"SELECT * FROM users WHERE users.id = #{user.sponsered_by_id} AND users.position = 'Left' "+
									"UNION ALL "+ 
									"SELECT users.* from r, users where users.id = r.sponsered_by_id)"+
									"SELECT * FROM r"
							records_array = ActiveRecord::Base.connection.execute(sql).to_a
							if records_array.present?
								@parent_users << User.where(sponsered_by_id: records_array.pluck("id"), position: "Left")
								@parent_users = User.where(sponsered_by_id: User.where(sponsered_by_id: records_array.pluck("id"), position: "Left"), position: "Left")
								if @parent_users.present?
									c = @parent_users.select { |c_user| c_user.try(:position) == "Left" && c_user.created_at > @user.created_at  && User.find_by(id: c_user.sponsered_by_id).try(:position) != "Right"}
									result << c
									@parent_users = []
								end
							end
						end
					end
				elsif @user.position == "Left" && User.find_by(id: @user.sponsered_by_id).try(:position) == "Right"
					if users.select {|user| user.position == "Left" }.present?
						users.each do |user|
							sql = " WITH RECURSIVE r AS ( "+ 
									"SELECT * FROM users WHERE users.id = #{user.sponsered_by_id} AND users.position = 'Right' "+
									"UNION ALL "+ 
									"SELECT users.* FROM users JOIN r on (r.id = users.sponsered_by_id)) "+
									"SELECT * FROM r"
							records_array = ActiveRecord::Base.connection.execute(sql).to_a
							if records_array.present?
								@parent_users << User.where(sponsered_by_id: records_array.pluck("id"))
							end
							@parent_users = @parent_users.flatten
							if @parent_users.present?
								c = @parent_users.select { |c_user| c_user.try(:position) == "Left" && c_user.created_at > @user.created_at}
								result << c
								@parent_users = []
							end

							sql = " WITH RECURSIVE r AS ( "+ 
									"SELECT * FROM users WHERE users.id = #{user.sponsered_by_id} AND users.position = 'Right' "+
									"UNION ALL "+ 
									"SELECT users.* from r, users where users.id = r.sponsered_by_id)"+
									"SELECT * FROM r"
							records_array = ActiveRecord::Base.connection.execute(sql).to_a
							if records_array.present?
								@parent_users << User.where(sponsered_by_id: records_array.pluck("id"))
							end
							@parent_users = @parent_users.flatten
							if @parent_users.present?
								c = @parent_users.select { |c_user| c_user.try(:position) == "Left" && c_user.created_at > @user.created_at}
								result << c
								@parent_users = []
							end
						end
					end
				elsif @user.position == "Right" && User.find_by(id: @user.sponsered_by_id).try(:position) == "Left"
					users.select {|user| user.position == "Right" }.each do |user|
						if user.sponsered_by_id.present?
							sql = " WITH RECURSIVE r AS ( "+ 
									"SELECT * FROM users WHERE users.id = #{user.sponsered_by_id} AND users.position = 'Left' "+
									"UNION ALL "+ 
									"SELECT users.* FROM users JOIN r on (r.id = users.sponsered_by_id)) "+
									"SELECT * FROM r"
							records_array = ActiveRecord::Base.connection.execute(sql).to_a
							if records_array.present?
								@parent_users << User.where(id: records_array.pluck("id"))
							end
							if @parent_users.present?
								c = @parent_users.select { |c_user| c_user.try(:position) == "Right" && c_user.created_at > @user.created_at && User.find_by(id: c_user.sponsered_by_id).try(:position) == "Right"}
								result << c
								@parent_users = []
							end

							sql = " WITH RECURSIVE r AS ( "+ 
									"SELECT * FROM users WHERE users.id = #{user.sponsered_by_id} "+
									"UNION ALL "+ 
									"SELECT users.* from r, users where users.id = r.sponsered_by_id) "+
									"SELECT * FROM r"

							records_array = ActiveRecord::Base.connection.execute(sql).to_a
							if records_array.present?
								@parent_users << User.where(sponsered_by_id: records_array.pluck("id").sort.last, position: "Right")
								@parent_users << User.where(sponsered_by_id: User.where(sponsered_by_id: records_array.pluck("id").sort.last, position: "Right").pluck(:id), position: "Right")
							end
							@parent_users = @parent_users.flatten


							if @parent_users.present?
								c = @parent_users.select { |c_user| c_user.try(:position) == "Right" && c_user.created_at > @user.created_at}
								result << c
								@parent_users = []
							end

							# if User.where(position: "Left", sponsered_by_id: nil).present?

							# 		users = User.where(sponsered_by_id: User.where(position: "Left", sponsered_by_id: nil).pluck(:id), position: "Right")
							# 		if users.present?
							# 			c = users.select { |c_user| c_user.try(:position) == "Right" && c_user.created_at > @user.created_at}
							# 			result << c
							# 			@parent_users = []
							# 		end
							# end
						end
					end	
				else
					users.select {|user| user.position == "Right" }.each do |user|
						if user.sponsered_by_id.present?
							sql = " WITH RECURSIVE r AS ( "+ 
									"SELECT * FROM users WHERE users.id = #{user.sponsered_by_id} AND users.position = 'Right' "+
									"UNION ALL "+ 
									"SELECT users.* FROM users JOIN r on (r.id = users.sponsered_by_id)) "+
									"SELECT * FROM r"
							records_array = ActiveRecord::Base.connection.execute(sql).to_a
							if records_array.present?
								@parent_users << User.where(id: records_array.pluck("id"))
							end

							if @parent_users.present?
								c = @parent_users.select { |c_user| c_user.try(:position) == "Right" && c_user.created_at > @user.created_at && User.find_by(id: c_user.sponsered_by_id).try(:position) == "Right"}
								result << c
								@parent_users = []
							end

							sql = " WITH RECURSIVE r AS ( "+ 
									"SELECT * FROM users WHERE users.id = #{user.sponsered_by_id} AND users.position = 'Right' "+
									"UNION ALL "+ 
									"SELECT users.* from r, users where users.id = r.sponsered_by_id)"+
									"SELECT * FROM r"

							records_array = ActiveRecord::Base.connection.execute(sql).to_a
							if records_array.present?
								@parent_users << User.where(sponsered_by_id: records_array.pluck("id"), position: "Right")
								@parent_users << User.where(sponsered_by_id: User.where(sponsered_by_id: records_array.pluck("id"), position: "Right"), position: "Right")
							end
							@parent_users = @parent_users.flatten

							if @parent_users.present?
								c = @parent_users.select { |c_user| c_user.try(:position) == "Right" && c_user.created_at > @user.created_at && User.find_by(id: c_user.sponsered_by_id).try(:position) == "Right"}
								result << c
								@parent_users = []
							end

							# if User.where(position: "Left", sponsered_by_id: nil).present?

							# 		users = User.where(sponsered_by_id: User.where(position: "Left", sponsered_by_id: nil).pluck(:id), position: "Right")
							# 		if users.present?
							# 			c = users.select { |c_user| c_user.try(:position) == "Right" && c_user.created_at > @user.created_at}
							# 			result << c
							# 			@parent_users = []
							# 		end
							# end
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
