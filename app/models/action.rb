include ApplicationHelper

class Action < ActiveRecord::Base
	belongs_to :user
end