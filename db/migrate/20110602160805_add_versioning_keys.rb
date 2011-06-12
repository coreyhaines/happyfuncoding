class AddVersioningKeys < ActiveRecord::Migration
	def self.up
		add_index :page_versions, :page_id
		add_index :page_versions, :user_id
		add_index :page_versions, :version

		add_index :program_versions, :program_id
		add_index :program_versions, :user_id
		add_index :program_versions, :version

		add_index :function_versions, :function_id
		add_index :function_versions, :user_id
		add_index :function_versions, :version
	end

	def self.down
	end
end
