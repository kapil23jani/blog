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


 end
