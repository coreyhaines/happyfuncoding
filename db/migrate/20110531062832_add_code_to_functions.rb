class AddCodeToFunctions < ActiveRecord::Migration
	def self.up
		add_column :functions, :code, :longtext
	end

	def self.down
		remove_column :functions, :code
	end
end
