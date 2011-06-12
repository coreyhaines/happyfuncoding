class AddFunctions < ActiveRecord::Migration
	def self.up
		create_table :functions do |t|
			t.integer :user_id
			t.string :name
		end
		add_index :functions, :user_id
		add_index :functions, :name
	end

	def self.down
		drop_table :functions
	end
end
