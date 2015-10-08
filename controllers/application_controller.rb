class ApplicationController < Sinatra::Application

  set :root, File.join(File.dirname(__FILE__), '..')
  set :public_folder, File.dirname(__FILE__) + '/../public' 
  set :views, File.expand_path('../../views', __FILE__)
  set :auth_config, AuthConfig.new
  set :environment, :production
  enable :static
  enable :sessions
  set :sessions, :expire_after => 2592000

  configure do
    Dir.mkdir('logs') unless File.exist?('logs')
    file = File.new("logs/common.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
  end  

  helpers ApplicationHelpers

  helpers do
    def auth_config
      settings.auth_config
    end

    def campaigns 
      @campaigns ||= Campaigns.load_from_file("./data/campaigns.json")
    end

    def catalogue
      @catalogue ||= Catalogue.load_from_mongodb
      @catalogue ||= Catalogue.load_from_file("./data/catalogue.json")
    end
  end

  # use Rack::Auth::Basic, "Restricted Area" do |username, password|
  #   username == auth_config.user and password == auth_config.pass
  # end

  namespace '/' do

    error Sinatra::NotFound do
      content_type 'text/plain'
      [404, 'Page Not Found']
    end

    get do
      erb :header
    end

    get 'catalogue' do      
        erb :catalogue, :locals => {:catalogue => catalogue}
    end

    get 'header' do
      erb :header
    end

    get 'sidebar' do
      erb :sidebar
    end

    get 'icon/:icon' do
      File.exist?("./public/upload/icon/#{params[:icon]}") ? File.read("./public/upload/icon/#{params[:icon]}") : File.read("./public/upload/icon/default.jpg")
    end 

    post 'category/:id/update' do 
      begin 
        unless params[:parent].nil? 
          p_entry = catalogue.content.find {|entry| params[:parent] == entry["id"]}
          if p_entry.nil? 
            params[:parent] = "0"
          elsif params[:parent] == params[:id]
            raise "same parent and child"
          else
            params[:parent] = p_entry["id"]
          end  
          catalogue.check_parent(params[:id], params[:parent])    
        end
        params[:price] = params[:price].to_f 
        params[:status] ||= "active"

        category = Category.new(params)        

        catalogue.update_category(category)
        catalogue.save_all
        catalogue.save_to_file("./data/catalogue.json") 
        halt 201, "saved"
      rescue Exception => e
        halt 400, e.message 
      end
    end

    post 'category/:id/addchild' do      
      category = Category.new({
        :parent => params[:id],
        :name => params[:name],
        :id =>  Random.rand(10000000000...99999999999).to_s 
        })
      catalogue.add_category(category)
      catalogue.save_all
      catalogue.save_to_file("./data/catalogue.json") 
      halt 201, "created"
    end

    post 'upload/:id/icon' do 
      file_ext = File.extname(params[:data][:filename])  
      filename = params["id"] + file_ext
      File.open('./public/upload/icon/' + filename, "w") do |f|
        f.write(params[:data][:tempfile].read)
      end
      halt 201, "file uploaded"    
    end
 
  end
end

require_relative 'builder'
