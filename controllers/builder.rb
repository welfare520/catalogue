class ApplicationController < Sinatra::Application

    get '/builder' do
      erb :builder, :locals => {:campaigns => campaigns}
    end

    get '/campaign/:id' do
    	response = campaigns.content.find {|entry| entry['id'] == params[:id]}
    	halt 200, response.to_json 
    end

    post '/campaign/:id/save' do    
    	campaign_hash = {
    		"id" => params[:id],
    		"company" => params[:company],
    		"onwer" => params[:owner],
    		"url" => params[:url],
    		"name" => params[:name],
    	}
    	puts campaign_hash
    	campaigns.update_campaign(campaign_hash)
    	campaigns.save_to_file("./data/campaigns.json")
    	halt 200, "saved"
    end

end