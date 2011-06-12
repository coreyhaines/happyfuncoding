class Program < ActiveRecord::Base
	belongs_to :user
	has_many :messages
	has_many :program_versions
end
