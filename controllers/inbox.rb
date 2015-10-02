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
                redirect "/users/beamer/#{uid}"
            rescue 
                redirect '/users/login'
            end
        end

        namespace '/beamer/:uid' do
            get do
                authenticate! 
                user = User.new(:id => params[:uid])
                erb :beamer, :locals => {:catalogue => catalogue, :user => user}
            end

            post '/:category' do
                authenticate! 
                user = User.new(:id => params[:uid])
                user.modify_profile(params[:category], params[:option], params[:selected])
                halt 201, "profile modified" 
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