class AddFieldsToPrograms < ActiveRecord::Migration
	def self.up
		add_column :programs, :start_code, :string
		add_column :programs, :loop_code, :string
	end

	def self.down
		remove_column :programs, :start_code
		remove_column :programs, :loop_code
	end
end
