class ChangeFunctionIdColumnName < ActiveRecord::Migration
	def self.up
		rename_column :function_versions, :function_id, :public_function_id
	end

	def self.down
	end
end
