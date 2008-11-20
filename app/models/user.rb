require 'digest/sha1'

# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base
  has_many :articles
  has_many :participants
  has_many :shows, :through => :participants
  has_many :headlines
  has_and_belongs_to_many :groups, :uniq=> true

  def self.authenticate(login, pass)
    @user = find_first(["login = ? AND password = ?", login, sha1(pass)]) or return nil
    
    #confirm that user is in the Geeks Group - if not do not allow to log in
    @group = Group.find_by_name("Geeks")
    if @user.groups.include?(@group) 
      return @user
    else
      return nil
    end
  end  

  def name
   if self.display_name 
     	self.display_name
   else
   		self.login
   end
  end

  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end
  
  def password_check?(pass)
   self.password == self.class.sha1(pass)
  end
  
  protected

  def self.sha1(pass)
    Digest::SHA1.hexdigest("change-me--#{pass}--")
  end
    
  before_create :crypt_password
  
  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end

  validates_length_of :login, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :login, :password, :password_confirmation, :on => :create
  validates_uniqueness_of :login, :on => :create
  validates_confirmation_of :password, :on => :create     
end
