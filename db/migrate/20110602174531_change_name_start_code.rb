class ChangeNameStartCode < ActiveRecord::Migration
	def self.up
		rename_column :program_versions, :start_cods, :start_code
	end

	def self.down
	end
end
