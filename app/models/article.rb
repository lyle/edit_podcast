class Article < ActiveRecord::Base
  has_and_belongs_to_many :images
  has_many :contributors, :order => "role"
  belongs_to :owner,
             :class_name => "User",
             :foreign_key => "user_id"
  belongs_to :teaser,
          :class_name => "Image",
          :foreign_key => "teaser_id"
  
  validates_presence_of :title, :slug, :abstract
  validates_length_of :title, :maximum=>64
  validates_uniqueness_of :slug
  
  # Using before_validation so we can default the slug from the title
  before_validation do |record|
    # Create slug from title
    if (record[:slug].nil? or record[:slug] == '') and !record[:title].nil?
      record[:slug] = record[:title].downcase.gsub( /[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s]+/, '_').gsub(/[\.:;=+]+/, '-').gsub(/[\-\_]{2,}/, '_').to_s
    else
      record[:slug] = record[:slug].downcase.gsub( /[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s]+/, '_').gsub(/[\.:;=+]+/, '-').gsub(/[\-\_]{2,}/, '_').to_s
    end
  end
  #original replacement someText.downcase.gsub( /[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=_+]+/, '-').gsub(/[\-]{2,}/, '-').to_s

  
  def link_to
  	if self.status == "live"
  	  return "<a href=\"#{self.view_url}\">view</a>"
  	else
  	  return "<a href=\"#{self.preview_url}\">preview</a>"
  	end
  end
  
  def view_url
  	return "#{GEEKSPEAK_URL}articles/#{self.slug}/"
  end
  def preview_url
  	return "#{GEEKSPEAK_URL}articles/#{self.slug}/preview"
  end
  
    before_save :nullContent
  #######
  private
  #######
  # check if this thing is live, if so publish it
  #def check_status
  #  if self.status == 'live' && self.publishid == nil
      # give the current article the next incremental avaialable publishid
  #    self.update_attribute("publishid", ((Article.find(:first,
  #      :conditions => "publishid IS NOT NULL",
  #      :order => "publishid DESC").publishid).to_int + 1 ))
  #  end
  #end
  #

    def nullContent
      if !(self.content.nil?) and self.content.length < 1
        self.content = nil
      end
      if !(self.category.nil?) and self.category.length < 1
        self.category = nil
      end
      if !(self.subtitle.nil?) and self.subtitle.length < 1
        self.subtitle = nil
      end
    end 
end
