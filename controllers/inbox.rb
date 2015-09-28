class ApplicationController < Sinatra::Application

    get '/inbox' do
      erb :inbox
    end

end