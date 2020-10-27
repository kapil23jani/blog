module DashboardHelper

	def get_final_users user
		result = []
		if user.present?
			result << User.where(sponsered_by_id: user.id)
			if User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id)}.present?
				result << User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id).present? ? User.where(sponsered_by_id: user.id) : nil}
				if User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id)}}.present?
					result << User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id).present? ? User.where(sponsered_by_id: user.id) : nil}}.present?
					if User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id)}}}.present?
						result << User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id).map{ |user| User.where(sponsered_by_id: user.id).present? ? User.where(sponsered_by_id: user.id) : nil}}}
					end
				end
			end
		end
		result.flatten.select {|user| user.is_a?(ActiveRecord::Base)}
	end
end
