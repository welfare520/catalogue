require 'virtus'
require './models/base_model'

class User < BaseModel
	include Virtus.model

	attribute :profile, Hash, :default => :fetch_profile

	def fetch_profile
		(find_by_id(id) || {id: id, profile: {}})[:profile]
	end

	def modify_profile(category_id, option, selected)        
        profile[category_id] ||= []
        if selected == 'true'
        	profile[category_id] << option
        else
        	profile[category_id].delete(option)
        end
        profile[category_id].uniq! 
        save_one({"id" => id, "profile"=> profile})
	end

	def validate_user 
	end
end