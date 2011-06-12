class ChangeToLongText < ActiveRecord::Migration
	def self.up
		change_column :pages, :text, :longtext		
		change_column :programs, :start_code, :longtext		
		change_column :programs, :loop_code, :longtext		
	end

	def self.down
	end
end
