class AddSaltToUsers < ActiveRecord::Migration
	def self.up
	    add_column :users, :salt, :text
		rename_column :users, :user_name, :name
	end

	def self.down
		remove_column :users, :salt
		rename_column :users, :name, :user_name
	end
end
