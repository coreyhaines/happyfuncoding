class AssetsToLongblob < ActiveRecord::Migration
	def self.up
		change_column :assets, :data, :longblob
	end

	def self.down
	end
end
