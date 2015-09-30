require 'virtus'

class Campaigns < BaseModel
	include Virtus.model
 
	attribute :content, Array

	def self.load_from_file(file)
		campaign_content = File.readlines(file).map do |line|
			JSON.parse(line)
		end
		Campaigns.new(:content => campaign_content)
	end

	def update_campaign(hash)
		index = content.find_index {|entry| entry['id'] == hash["id"]}
		content[index] = hash
	end

	def save_to_file(output_file)
		File.open(output_file, "w") do |file|
			content.each do |entry|
				file.puts entry.to_json 
			end			
		end
	end
end