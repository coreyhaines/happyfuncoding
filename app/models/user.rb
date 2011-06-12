include ApplicationHelper

class User < ActiveRecord::Base
	has_many :programs
	has_many :friendships
	has_many :friends, :through=>:friendships
	has_many :messages
	has_many :actions
	has_many :assets
	
	cattr_accessor :current_user

	def password=(new_password)
		@password = new_password
		self.salt = "#{id}_#{rand(100000)}_#{Time.now}"
		self.encrypted_password = encrypt_a_password( new_password, salt )
	end

	def validate_password( clear_password )
		encrypt_a_password( clear_password, salt ) == encrypted_password
	end

	def encrypt_a_password( plaintext, salt )
		salted_password = Digest::SHA256.hexdigest( plaintext + salt )
	end						   	
	
	def self.find_by_name_and_password( name, password )
		user_to_validate = self.find( :first, :conditions=>["name=?",name] )
		if user_to_validate
			if ! user_to_validate.validate_password( password )
				return nil
			end
		end
		return user_to_validate
	end
	
	def super_user?
		return name=="zack" || name == "rcorell"
	end
	
	def log_action action
		a = Action.new
		a.user_id = self.id
		a.action = action
		a.save!
	end
			
end
