class AddIndexToMessages < ActiveRecord::Migration
	def self.up
		add_column :messages, :message, :longtext
		add_index :messages, :user_id
		add_index :messages, :program_id
	end

	def self.down
		remove_column :messages, :message
		remove_index :messages, :user_id
		remove_index :messages, :program_id
	end
end
