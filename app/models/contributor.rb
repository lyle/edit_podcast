class Contributor < ActiveRecord::Base
	belongs_to :article
	belongs_to :user
	
	ROLES = ["author", "contributor", "editor", "photographer"]
end
