class PublicFunction < ActiveRecord::Base
	belongs_to :user
	has_many :function_versions
		
	def self.find_by_name name
		f = nil

		begin
			f = find( :first, :conditions=>["name=?",name] )
		rescue
		end
		
		return f

	end
end