class Group < ActiveRecord::Base
	has_and_belongs_to_many :users, :uniq=> true
	belongs_to :creator,
             :class_name => "User",
             :foreign_key => "created_by"
	
   def before_destroy
     raise "CantDeleteWithChildren" unless users.empty?
   end
end
