class AddFriends < ActiveRecord::Migration
	def self.up
		create_table :friends, :id => false do |t|
			t.integer :user_id
			t.integer :friend_user_id
		end	
	end

	def self.down
		drop_table :friends
	end
end
