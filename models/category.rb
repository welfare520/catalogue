require 'virtus'

class Category
	include Virtus.model

	attribute :id, String
	attribute :name, String
	attribute :name_en, String
	attribute :name_es, String
	attribute :description, String 
	attribute :type, String 

	attribute :parent, String
	attribute :pic, String

	attribute :status, String 
end