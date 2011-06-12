class MakeAssets < ActiveRecord::Migration
	def self.up
		create_table :assets do |t|
			t.string :name
			t.binary :data
			t.timestamps
		end
	end

	def self.down
	end
end
