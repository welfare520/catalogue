class ApplicationController < Sinatra::Application

  set :root, File.join(File.dirname(__FILE__), '..')
  set :public_folder, File.dirname(__FILE__) + '/../public' 
  set :views, File.expand_path('../../views', __FILE__)
  set :auth_config, AuthConfig.new
  enable :static

  helpers ApplicationHelpers

  helpers do
    def auth_config
      settings.auth_config
    end

    def catalogue
      @catalogue ||= Catalogue.load_from_file("./data/catalogue.json")
    end
  end

  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == auth_config.user and password == auth_config.pass
  end

  namespace '/' do

    get do      
      erb :catalogue, :locals => {:catalogue => catalogue}
      # catalogue = load_catalogue(es_config.catalogue_client, es_config.catalogue_index)
      # catalogue.catalogue.delete_if {|key, value| value.status != 'active' || value.category.size > 3}
      # catalogue.add_subcategories
      # catalogue.add_entry_hash
      # erb :accordion, :locals => {:catalogue => catalogue, :es_host => es_config.catalogue_host}
    end

    get 'icon/:icon' do
      File.read("./public/icon/#{params[:icon]}")
    end 

    post 'category/:id/update' do 

      unless params[:parent].nil? 
        params[:parent] = "root" if catalogue.content.find {|entry| params[:parent] == entry["id"]}.empty? 
      end
      category = Category.new(params)

      catalogue.update_category(category)
      catalogue.save_to_file("./data/catalogue.json") 
      "saved"
    end

    post 'upload/:id/icon' do 
      file_ext = File.extname(params[:data][:filename])  
      filename = params["id"] + file_ext
      File.open('./public/icon/' + filename, "w") do |f|
        f.write(params[:data][:tempfile].read)
      end
      "file uploaded"
    end

    # get 'all' do
    #   catalogue = load_catalogue(es_configd.catalogue_client, es_config.catalogue_index)
    #   catalogue.catalogue.delete_if {|key, value| value.category.size > 3}
    #   catalogue.add_subcategories
    #   catalogue.add_entry_hash
    #   erb :accordion, :locals => {:catalogue => catalogue, :es_host => es_config.catalogue_host}
    # end

    # get 'planned' do
    #   catalogue = load_catalogue(es_config.catalogue_client, es_config.catalogue_index)
    #   catalogue.catalogue.delete_if {|key, value| value.status != 'planned' || value.category.size > 3}
    #   catalogue.add_subcategories
    #   catalogue.add_entry_hash
    #   erb :accordion, :locals => {:catalogue => catalogue, :es_host => es_config.catalogue_host}
    # end

    # post 'category/:id/' do
    #   hash = {
    #           :id => params[:id],
    #           :type => params[:type],
    #           :description => params[:desc]
    #          }
    #   entry = CatalogueEntry.new(hash)
    #   entry.check_type
    #   CategoryStore.update_category(entry)
    #   status 200
    #   body "Data have been saved!"
    # end
  end

end
