class ChangeFriends < ActiveRecord::Migration
	def self.up
		rename_column :friends, :friend_user_id, :friend_id
		rename_table :friends, :friendships
	end

	def self.down
		rename_table :friendships, :friends
		rename_column :friends, :friend_id, :friend_user_id
	end
end
