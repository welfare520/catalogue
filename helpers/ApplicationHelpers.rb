module ApplicationHelpers

    def authenticate! 
        session_id = env["rack.session"]["session_id"]    
        unless Sessions.new.session_valid?(session_id, params[:uid])  
            redirect '/users/login'
        end   
    end

end
