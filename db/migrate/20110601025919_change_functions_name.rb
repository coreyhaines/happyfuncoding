class ChangeFunctionsName < ActiveRecord::Migration
	def self.up
		rename_table :functions, :public_functions
	end

	def self.down
		rename_table :public_functions, :functions
	end
end
