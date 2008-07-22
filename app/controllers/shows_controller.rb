class ShowsController < ApplicationController
  include LoginSystem 
  require 'open-uri'
  
  layout  'application'
  before_filter :login_required
  
  def index
    list
    render :action => 'list'
  end

  def list
    @show_pages, @shows = paginate :show, :per_page => 20, :order => "showtime DESC"
    @user = @session[:user]
  end

  def show
    @show = Show.find(params[:id])
  end

  def new
    @show = Show.new
    @user = @session[:user]
    respond_to do |type| 
      type.html {
         render
      } 
      type.js {
        render  :layout => false
        
      }
    end
  end

  def create
    @show = Show.new(params[:show])
    @show.owner = @session[:user]
    if @show.save
      flash[:notice] = 'Show was successfully created.'
      
      redirect_to :action => 'edit', :id => @show
    else
      render :action => 'new'
    end
  end

  def edit
    @show = Show.find(params[:id])
    @geeks = Group.find(:first, :conditions => ["name = 'Geeks'"], :include => :users ).users
    @user = @session[:user]
    @headlineOrfins = Headline.find_by_sql(" SELECT headlines.* FROM headlines LEFT OUTER JOIN  headline_discussions ON (headlines.id = headline_discussions.headline_id) WHERE headline_discussions.id IS NULL ORDER BY headlines.id DESC")
  end

  def update
  	@user = @session[:user]
    @geeks = Group.find(:first, :conditions => ["name = 'Geeks'"], :include => :users ).users
    @show = Show.find(params[:id])
  	begin
  	    @show.update_attributes(params[:show])
    rescue ActiveRecord::StaleObjectError
        @existing_show = Show.find(params[:id])
        @show.lock_version = @existing_show.lock_version
        if !(@show.abstract == @existing_show.abstract)
        		@show.errors.add('abstract',' is different between what is in the DB and what you have tried to submit.')
        end 
        if !(@show.content == @existing_show.content)
        		@show.errors.add('content',' is different between what is in the DB and what you have tried to submit.')
        end
        if !(@show.title == @existing_show.title)
        		@show.errors.add('title',' is different between what is in the DB and what you have tried to submit.')
        end
        @show.errors.add_to_base('Another person edited this show and saved it before you did. If we had allowed this save then we would have lost their work.')
        render :action => 'edit' and return
    end
    if @show.errors.empty?
      redirect_to :action => 'edit', :id => params[:id] and return
    else
    	render :action => 'edit' and return
    end
  end

  def preview_show(da_show)
  	return "#{GEEKSPEAK_URL}shows/#{da_show.showtime.strftime('%Y/%m/%d')}/.preview"
  end
  def view_show(da_show)
  	return "#{GEEKSPEAK_URL}shows/#{da_show.showtime.strftime('%Y/%m/%d')}/"
  end
  helper_method :preview_show, :view_show

  def destroy
    Show.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def add_participant
    @show = Show.find(params[:show_id])
    user_id = params[:id].split("_")[1]
    @user = User.find(user_id)
    role = params["role"]
    if (role == "host")
      @show.participants.each do |participant|
        participant.destroy if participant.role == "host"
      end
    end
    @participant = Participant.create(:role=>role, :user=>@user, :show=>@show)
    @show = Show.find(params[:show_id])
    @role = role
    render :action => "participants_of_role"
  end
  
  def destroy_participant
    participant = Participant.find(params[:id])
    @role = participant.role
    @show = participant.show
    participant.destroy
    render :action => "participants_of_role"
  end
  
  
  def preview
    @show = Show.find(params[:id])
    @html = open ( @show.preview_url,
              'User-Agent' => 'edit-geekspeak').read
    temp_file = File.new("#{RAILS_ROOT}/tmp/cache/show_#{@show.id}_cache.html", "w")
    temp_file.write("#{@html}")
    
    @html["<head>"] = "<head><base href='#{@show.view_url}' />"
    render  :layout => false
  end
  def publish
    @show = Show.find(params[:id])
    if File.exists?("#{RAILS_ROOT}/tmp/cache/show_#{@show.id}_cache")
        flash[:notice] = "I couldn't find the preview file, start over."
        redirect_to :action => 'edit', :id => @show 
    else
      	begin
      	 
      	 Dir.mkdir("#{RAILS_ROOT}/public/shows-link/#{@show.showtime.strftime('%Y')}") unless
      	  File.exists?("#{RAILS_ROOT}/public/shows-link/#{@show.showtime.strftime('%Y')}")
      	 Dir.mkdir("#{RAILS_ROOT}/public/shows-link/#{@show.showtime.strftime('%Y/%m')}") unless
        	  File.exists?("#{RAILS_ROOT}/public/shows-link/#{@show.showtime.strftime('%Y/%m')}")
      	 Dir.mkdir("#{RAILS_ROOT}/public/shows-link/#{@show.showtime.strftime('%Y/%m/%d')}") unless
          	  File.exists?("#{RAILS_ROOT}/public/shows-link/#{@show.showtime.strftime('%Y/%m/%d')}")
          	  
         File.rename("#{RAILS_ROOT}/tmp/cache/show_#{@show.id}_cache.html",
      	             "#{RAILS_ROOT}/public/shows-link/#{@show.showtime.strftime('%Y/%m/%d')}/index.html")
      	  
      	rescue ActiveRecord::StaleObjectError
           flash[:notice] = 'I couldn\'t write the file.'
           redirect_to :action => 'edit', :id => @show
      	end 
      	@show.status = 'live'
      	@show.save
      	flash[:notice] = 'The show has been published.'
      	redirect_to :action => 'edit', :id => @show
    end
  end
  
end
