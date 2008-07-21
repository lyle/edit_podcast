class HeadlinesController < ApplicationController

  layout  'application'
  before_filter :login_required


  def index
    list
    render :action => 'list'
  end
  
#    layout  'api'
  in_place_edit_for :headline, :title
  in_place_edit_for :headline, :content
  in_place_edit_for :headline, :url
  in_place_edit_for :headline, :status

  def list
    
    if (params[:show_id])
      @show = Show.find(params[:show_id])
      @headlines = @show.headlines
    else
      @headline_pages, @headlines = paginate :headline, :per_page => 20, :order => "created_at DESC"
      @user = @session[:user]
    end

  end
  
  def new
    @headline = Headline.new(params[:headline])
    @headline.user = @session[:user]
    @returnurl = params[:returnurl]
    respond_to do |type| 
      type.html {
         render
      } 
      type.js {
        render  :layout => false
        
      }
    end
  end
  def edit
    @headline = Headline.find(params[:id])
  end
  def create
    @headline = Headline.new(params[:headline])
    @headline.user = @session[:user]
    if @headline.save
      if params[:show_id]
        redirect_to :controller => 'headline_discussions',
            :action => 'create',
            :show_id => params[:show_id],
            :headline_id => @headline
      elsif (params[:returnurl])
        redirect_to params[:returnurl]
      else
        flash[:notice] = 'News was successfully created.'
        redirect_to :action => 'list'
      end
    else
      flash[:notice] = 'A problem occured creating the headline.. odd text?'
      respond_to do |type| 
        type.html {
          redirect_to :controller => 'headlines' , :action => 'new'
        } 
        type.js { render } 
      end
    end
  end
  
  def update
    @headline = Headline.find(params[:id])
    if @headline.update_attributes(params[:headline])
      flash[:notice] = 'News was successfully updated.'
      respond_to do |type| 
        type.html {
          redirect_to :controller => 'headlines' , :action => 'list'
        } 
        type.js { render } 
      end
    else  
      flash[:notice] = 'A problem occured updating the headline.'
      respond_to do |type| 
        type.html {
          redirect_to :controller => 'headlines' , :action => 'edit'
        } 
        type.js { render } 
      end
    end
  end
  def destroy
    @headline = Headline.find(params[:id])
    if @headline.destroy
      flash[:notice] = 'You killed a news item.'
    else
      flash[:notice] = 'You tried to kill a news item, but...'
    end
  end
  
  def set_title
    @headline = Headline.find(params[:id])
    if (! params[:value].nil? and params[:value] != "")
      @headline.title = params[:value]
      @headline.save
      @headline.reload
    end
    render :text => @headline.send(:title)
  end
  def set_content
    @headline = Headline.find(params[:id])
    if (! params[:value].nil? and params[:value] != "")
      @headline.content = params[:value]
      @headline.save
      @headline.reload
    end
    render :text => @headline.send(:content)
  end
  def set_url
    @headline = Headline.find(params[:id])
    @headline.url = params[:value]
    @headline.save
    @headline.reload
    if @headline.url.nil? 
      render :text => ''
    else
      render :text => @headline.send(:url)
    end
  end
  def set_status
    @headline = Headline.find(params[:id])
    @headline.status = params[:value]
    @headline.save
    @headline.reload
    render :text => @headline.send(:status)
  end
  def toggle_status
    @headline = Headline.find(params[:id])
    if @headline.status == "on"
      @headline.status = "off"
    else
      @headline.status = "on"
    end
    @headline.save
    @headline.reload
  end
end
