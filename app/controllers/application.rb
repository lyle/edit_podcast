# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
require_dependency "login_system"
class ApplicationController < ActionController::Base
  include LoginSystem
  model :user
  
  layout  'application'
  def index
    redirect_to :controller => 'shows', :action => 'list'
  end
  
end
