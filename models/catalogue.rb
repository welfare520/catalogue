require 'virtus'

class Catalogue
	include Virtus.model

	attribute :content, Array
	attribute :content_hash, Hash 

	def self.load_from_file(file)
		category_content = File.readlines(file).map do |line|
			JSON.parse(line)
		end
		catalogue = Catalogue.new(:content => category_content)
		catalogue.add_children
		catalogue 
	end

	def save_to_file(output_file)
		File.open(output_file, "w") do |file|
			content.each do |entry|
				entry.delete('children')
				file.puts entry.to_json 
			end			
		end
	end

	def add_category(category)
		cat_new = {}
		Hash[category.attributes.map{ |k, v| [k.to_s, v] }].each do |k, v|
			cat_new[k] = v unless v.nil?   
		end	
		content << cat_new
	end

	def update_category(category)
		category_index = content_hash[category.id]
		Hash[category.attributes.map{ |k, v| [k.to_s, v] }].each do |k, v|
			content[category_index][k] = v unless v.nil?   
		end		
	end

	def check_parent(id, parent_id)
		content[content_hash[id]]['children'].each do |cid|
			puts content[content_hash[cid]]["id"]
			puts parent_id
			raise "Category tree looped!" if content[content_hash[cid]]["id"] == parent_id
			check_parent(id, cid)
		end
	end

	def add_children
		@content_hash = Hash[*content.map.with_index {|entry, index| [entry['id'], index]}.flatten]
		content.each do |category|
			p_index = content_hash[category["parent"]]
			unless p_index.nil?
			   content[p_index]['children'] ||= []
               content[p_index]['children'] << category['id']
			end
			category['children'] ||= []
			category['children'].uniq! 
		end
	end
end