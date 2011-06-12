class AddVersioning < ActiveRecord::Migration
	def self.up
		create_table :page_versions do |t|
			t.integer :page_id
			t.integer :user_id
			t.integer :version
			t.timestamps
		end
		
		add_column :page_versions, :text, :longtext
		
		create_table :program_versions do |t|
			t.integer :program_id
			t.integer :user_id
			t.integer :version
			t.timestamps
		end

		add_column :program_versions, :code, :longtext

		create_table :function_versions do |t|
			t.integer :function_id
			t.integer :user_id
			t.integer :version
			t.timestamps
		end
		
		add_column :function_versions, :code, :longtext
	end

	def self.down
	end
end
