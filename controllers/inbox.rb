class ApplicationController < Sinatra::Application

	namespace '/users' do

        get '/login' do
            erb :login 
        end

        post '/login_process' do
            begin 
                session_id = env["rack.session"]["session_id"] 
                raise "user name cannot be empty" if params[:username].empty? 
                uid = params[:username].gsub(/\s+/,"")
                Sessions.new.create_session(session_id, uid)
                redirect "/users/inbox/#{uid}"
            rescue 
                redirect '/users/login'
            end
        end

        namespace '/inbox/:uid' do
            get do
                authenticate!
                active_campaigns = campaigns.content.first(9)
                erb :inbox, :locals => {:campaigns => active_campaigns, :user => params[:uid]}
            end
        end
        
    end
end