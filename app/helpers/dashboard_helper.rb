module DashboardHelper

	def get_final_users user, start_date = nil, end_date = nil
		@user = user
		if user.present?
			result = []
			users = []
			sql = "WITH RECURSIVE child_users(id,sponser_id, sponsered_by_id,h_parent, position,lvl) AS 
					( SELECT id,sponser_id, sponsered_by_id, h_parent, position, 0 FROM users 
					WHERE users.id = #{user.id}
					UNION ALL SELECT  users.id,users.sponser_id, users.sponsered_by_id, users.h_parent,users.position,child_users.lvl+1 FROM users JOIN child_users
					ON child_users.id = users.h_parent) 
					SELECT id, sponser_id,sponsered_by_id, h_parent,lvl FROM child_users;"			
			records_array = ActiveRecord::Base.connection.execute(sql).to_a
			if records_array.present?
				if start_date.nil?
					result << User.where(id: records_array.pluck("id")).sort
				else
					result << User.where(id: records_array.pluck("id")).where('created_at BETWEEN ? AND ?', start_date[:start_date], start_date[:end_date]).sort

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

    def get_chart_for_users user
		@user = user
		if user.present?
			result = []
			users = []
			sql = "WITH RECURSIVE child_users(id,sponser_id, sponsered_by_id,h_parent, position,lvl, name) AS 
					( SELECT id,sponser_id, sponsered_by_id, h_parent, position, 0, name FROM users 
					WHERE users.id = #{user.id}
					UNION ALL SELECT  users.id,users.sponser_id, users.sponsered_by_id, users.h_parent,users.position,child_users.lvl+1, users.name FROM users JOIN child_users
					ON child_users.id = users.h_parent) 
					SELECT id, h_parent, sponser_id,position ,lvl, name FROM child_users;"			
			records_array = ActiveRecord::Base.connection.execute(sql).to_a
			if records_array.present?
				records_array.sort_by { |record| record['id'].to_i }
			end
		end
	end
end
