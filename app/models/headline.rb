class Headline < ActiveRecord::Base
  #each headline can be attached to only one show
	has_one :headline_discussion
  has_many :shows, :through => :headline_discussions
	belongs_to :user
	
	validates_presence_of :title, :on => :create, :message => "can't be blank"
	validates_presence_of :content, :on => :create, :message => "can't be blank"
	
	def orphans
	  return Headline.find(:all, :condition=>" SELECT headlines.* FROM headlines, headline_discussions WHERE headlines.id = headline_discussions.id AND headline_discussions.id IS NULL")
	end
	
	
	before_save :nullContent
   #######
   private
   #######
   def nullContent
     if !(self.url.nil?) and self.url.length < 1
       self.url = nil
     end
   end
  
	
	
end
