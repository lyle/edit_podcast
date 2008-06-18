class Participant < ActiveRecord::Base
	belongs_to :show
	belongs_to :user
	
	ROLES = ["host", "cohost", "guest", "phones"]

end
