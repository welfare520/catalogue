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
  end

  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == auth_config.user and password == auth_config.pass
  end

  namespace '/' do

    get do
      erb :catalogue
      # catalogue = load_catalogue(es_config.catalogue_client, es_config.catalogue_index)
      # catalogue.catalogue.delete_if {|key, value| value.status != 'active' || value.category.size > 3}
      # catalogue.add_subcategories
      # catalogue.add_entry_hash
      # erb :accordion, :locals => {:catalogue => catalogue, :es_host => es_config.catalogue_host}
    end

    # get 'all' do
    #   catalogue = load_catalogue(es_config.catalogue_client, es_config.catalogue_index)
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
