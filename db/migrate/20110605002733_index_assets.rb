class IndexAssets < ActiveRecord::Migration
	def self.up
		add_column :assets, :user_id, :integer
		add_index :assets, :user_id
		add_index :assets, :name
	end

	def self.down
	end
end
