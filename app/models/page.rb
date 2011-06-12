include ApplicationHelper

class Page < ActiveRecord::Base
	has_many :page_versions
end
