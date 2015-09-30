require 'virtus'

class Sessions < BaseModel
	include Virtus.model

	def create_session(session_id, user)
        save_one({"id" => session_id, "user"=>user, "time" => Time.now})
	end

	def session_valid?(session_id, user)
		if find_by_id(session_id).nil?
            false 
		elsif find_by_id(session_id)["time"] < Time.now - 3600
			false 
		elsif find_by_id(session_id)["user"] != user
            false 
		else
			update_session(session_id)
			true
		end
	end

	def update_session(session_id)
        @@client[self.class.name.to_sym]
	        .find(:id => session_id)
	        .update_one({"$set" => {"time" => Time.now}}, { :upsert => false })
	end
end