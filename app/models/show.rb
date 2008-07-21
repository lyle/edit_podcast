class Show < ActiveRecord::Base
  has_and_belongs_to_many :questions
  has_and_belongs_to_many :images
  has_many :participants, :order => "role"
  has_many :users,  :through => :participants
  has_many :headline_discussions, :order => "position"
  has_many :headlines, :through => :headline_discussions
  belongs_to :owner,
             :class_name => "User",
             :foreign_key => "user_id"
  belongs_to :teaser,
          :class_name => "Image",
          :foreign_key => "teaser_id"
  
  validates_presence_of :title, :abstract   
  validates_length_of :title, :maximum=>64
  validates_uniqueness_of :showtime
  
  STATUSES = [["New Show", "new"], ["Waiting", "waiting"], ["Pending Approval", "pending"],["Live","live"]]
  
  
  
  def link_to_show
  	if self.status == "live"
  	  return "<a href=\"#{self.view_url}\" target=\"_blank\">view</a>"
  	else
  	  return "<a href=\"#{self.preview_url}\" target=\"_blank\">preview</a>"
  	end
  end
  
  
  def view_url
  	return "#{GEEKSPEAK_URL}shows/#{self.showtime.strftime('%Y/%m/%d')}/"
  end
  def preview_url
  	return "#{GEEKSPEAK_URL}shows/#{self.showtime.strftime('%Y/%m/%d')}/.preview"
  end
  before_save :nullContent
  
  private
    def nullContent
      if !(self.content.nil?) and self.content.length < 1
        self.content = nil
      end
    end 
end
