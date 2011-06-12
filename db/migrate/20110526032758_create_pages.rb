class CreatePages < ActiveRecord::Migration
	def self.up
		create_table :pages do |t|
			t.integer :user_id
			t.string :name
			t.string :text
			t.timestamps
		end

		add_index :pages, :user_id
		add_index :pages, :name
		add_index :programs, :user_id
		add_index :programs, :name
		add_index :users, :name
		add_index :users, :facebook_id
	end
	
	def self.down
	    drop_table :pages

		remove_index :pages, :user_id
		remove_index :pages, :name
		remove_index :programs, :user_id
		remove_index :programs, :name
		remove_index :users, :name
		remove_index :users, :facebook_id
	end
end
