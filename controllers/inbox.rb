class ApplicationController < Sinatra::Application

	namespace '/inbox' do
	    get do
	    	mongodb[:catalogue].insert_one({ id: '1' })
            erb :inbox
        end
    end
end