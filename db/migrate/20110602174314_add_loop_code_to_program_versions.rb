class AddLoopCodeToProgramVersions < ActiveRecord::Migration
	def self.up
		add_column :program_versions, :loop_code, :longtext
		rename_column :program_versions, :code, :start_cods
	end

	def self.down
	end
end
