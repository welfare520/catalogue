require 'virtus'

class Catalogue
	include Virtus.model

	attribute :content, Array

	def self.load_from_file(file)
		category_content = File.readlines(file).map do |line|
			JSON.parse(line)
		end
		Catalogue.new(:content => category_content)
	end

	def save_to_file(output_file)
		File.open(output_file, "w") do |file|
			content.each do |entry|
				file.puts entry.to_json 
			end			
		end
	end

	def update_category(category)
		category_index = content.find_index {|entry| entry["id"] == category[:id]}
		Hash[category.attributes.map{ |k, v| [k.to_s, v] }].each do |k, v|
			content[category_index][k] = v unless v.nil?   
		end		
	end

end