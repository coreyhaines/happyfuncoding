class RemoveVersionColumn < ActiveRecord::Migration
	def self.up
		remove_column :page_versions, :version
		remove_column :program_versions, :version
		remove_column :function_versions, :version
	end

	def self.down
	end
end
