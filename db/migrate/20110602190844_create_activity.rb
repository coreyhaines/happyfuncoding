class CreateActivity < ActiveRecord::Migration
	def self.up
		create_table :activity do |t|
			t.integer :user_id
			t.string :action
			t.timestamps
		end
		add_index :activity, :user_id
	end

	def self.down
	end
end
