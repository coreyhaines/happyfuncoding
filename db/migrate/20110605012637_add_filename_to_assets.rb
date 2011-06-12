class AddFilenameToAssets < ActiveRecord::Migration
	def self.up
		add_column :assets, :filename, :string
	end

	def self.down
	end
end
