class RenameActivity < ActiveRecord::Migration
	def self.up
		rename_table :activity, :actions
	end

	def self.down
	end
end
